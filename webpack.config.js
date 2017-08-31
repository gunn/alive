var path = require('path')
var webpack = require('webpack')

module.exports = {
  entry: [
    './app.coffee'
  ],

  output: {
    filename: 'app.js'
  },

  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [
          "babel-loader",
          "coffee-loader"
        ]
      }
    ]
  },

  resolve: {
    modules: [
      './node_modules'
    ]
  }
}
