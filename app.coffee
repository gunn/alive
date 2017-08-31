import { h, render, Component } from 'preact'

WIDTH     = 80
HEIGHT    = 120
GRID_SIZE = 10

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

cellFor = (x, y)-> grid[x][y]

for x in [0..WIDTH-1]
  for y in [0..HEIGHT-1]
    cell = grid[x][y]

    for dx in [-1..+1]
      for dy in [-1..+1]
        unless dx==0 && dy==0
          coords = wrapXY(x+dx, y+dy)
          cell.neighbours.push cellFor(coords...)

styles = "
.row {
  line-height: 0;
}

.cell {
  display: inline-block;
  width: #{GRID_SIZE}px;
  height: #{GRID_SIZE}px;
}

.alive {
  background-color: #3F6;
}
"


runTick = ->
  for cell in cells
    count = cell.neighbours.filter(({alive})=> alive).length

    cell.keepAlive = if cell.alive
      count==2 || count==3
    else
      count==3
  
  for cell in cells
    cell.alive = cell.keepAlive


Square = ({alive}) ->
  className = "cell"
  className += " alive" if alive
  h "span", className: className

class Grid extends Component
  constructor: ->
    super()
    @state = time: Date.now
  
  componentDidMount: ->
    reRender = =>
      @setState time: Date.now
      runTick()
      # window.requestAnimationFrame
      window.requestAnimationFrame reRender, 500
    reRender()

  render: ->
    h "div", className: "grid",
      for row in grid
        h "div", className: "row",
          for cell in row
            h Square, {alive: cell.alive}

App = =>
  h "div", null,
    h "style", type: "text/css", styles

    h Grid


render h(App), document.body
