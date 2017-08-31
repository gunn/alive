import { h, render, Component } from 'preact'

WIDTH     = 80
HEIGHT    = 80
GRID_SIZE = 10

getRandomGrid = ->
  for x in [1..WIDTH]
    for y in [1..HEIGHT]
      Math.random() > 0.5

grid = getRandomGrid()

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

Cell = ({on: value}) ->
  className = "cell"
  className += " alive" if value
  h "span", className: className

App = =>
  h "div", null,
    h "style", type: "text/css", styles

    h "div", className: "grid",
      for row in grid
        h "div", className: "row",
          for value in row
            h Cell, on: value

render h(App), document.body
