import { h, render, Component } from 'preact'

WIDTH     = 50
HEIGHT    = 50
GRID_SIZE = 10

getRandomGrid = ->
  for x in [1..WIDTH]
    for y in [1..HEIGHT]
      Math.random() > 0.5

grid = getRandomGrid()

Cell = ({on: value}) ->
  h "span", className: "cell",
    if value then "X" else "..."

App = =>
  h "div", className: "grid",
    for row in grid
      h "div", className: "row",
        for value in row
          h Cell, on: value

render h(App), document.body
