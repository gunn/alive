import { h, render, Component } from 'preact'

WIDTH     = 80
HEIGHT    = 120
GRID_SIZE = 10
PADDING   = 8

class Cell
  constructor: (@alive) ->
    @neighbours = []


getRandomGrid = ->
  for x in [0..WIDTH-1]
    for y in [0..HEIGHT-1]
      alive = Math.random() > 0.5
      new Cell(alive)

grid = getRandomGrid()
cells = grid.reduce (a, b) -> [a..., b...]


wrapXY = (x, y)->
  wx = if x >= WIDTH
      x - WIDTH
    else if x < 0
      x + WIDTH
    else x
  
  wy = if y >= HEIGHT
      y - HEIGHT
    else if y < 0
      y + HEIGHT
    else y

  [wx, wy]


for x in [0..WIDTH-1]
  for y in [0..HEIGHT-1]
    cell = grid[x][y]

    for dx in [-1..+1]
      for dy in [-1..+1]
        unless dx==0 && dy==0
          [cx, cy] = wrapXY(x+dx, y+dy)
          cell.neighbours.push grid[cx][cy]


styles = "
.alive-grid {
  background-color: #FFF;
  padding: #{PADDING}px;
  width: #{HEIGHT*GRID_SIZE + PADDING*2}px;
  height: #{WIDTH*GRID_SIZE + PADDING*2}px;
}

.alive-row {
  line-height: 0;
}

.alive-cell {
  display: inline-block;
  width: #{GRID_SIZE}px;
  height: #{GRID_SIZE}px;
}

.alive {
  background-color: #a8d46f;
}
"

ruleTable = [
  # x = number of alive neighbours
  [0, 0, 0, 1, 0, 0, 0, 0, 0], #dead
  [0, 0, 1, 1, 0, 0, 0, 0, 0]  #alive
]


runTick = ->
  for cell in cells
    count = cell.neighbours.filter(({alive})=> alive).length

    cell.keepAlive = Math.random() < ruleTable[~~cell.alive][count]
  
  for cell in cells
    cell.alive = cell.keepAlive


class Square extends Component
  shouldComponentUpdate: ({alive})->
    alive != @props.alive
  
  render: ->
    className = "alive-cell"
    className += " alive" if @props.alive
    h "span", className: className


class Grid extends Component
  constructor: ->
    super()
    @state = time: Date.now
  
  componentDidMount: ->
    reRender = =>
      return if this.unmounted

      @setState time: Date.now
      runTick()
      window.requestAnimationFrame reRender
    reRender()

  componentWillUnmount: ->
    this.unmounted = true

  render: ->
    h "div", className: "alive-grid",
      for row in grid
        h "div", className: "alive-row",
          for cell, i in row
            h Square, alive: cell.alive, key: i


App = =>
  h "div", null,
    h "style", type: "text/css", styles

    h Grid


render h(App), document.body
