_ = require 'lodash'
express = require 'express'
fs = require 'fs'

app = express()
emoticons = JSON.parse fs.readFileSync __dirname + '/../data/emoticons.json'

app.get '/', (req, res) ->
  res.send getPage()

getPage = ->
  """
    <!doctype html>
    <html>
      <head>
        <style>
          body {
            background: #eee;
          }
          .list {
            font-size: 16px;
            font-family: arial, sans-serif;
            color: #555;
          }
          .list > div {
            display: inline-block;
            margin: 5px;
            padding: 5px 10px;
            background: #fff;
            height: 40px;
            line-height: 40px;
          }
        </style>
      </head>
      <body>
        <div class='list'>
          #{getList()}
        </div>
      </body>
    </html>
  """

getList = ->
  _.shuffle emoticons
  .map (x) -> "<div>#{x}</div>"
  .join ''

server = app.listen 3000, ->
  {port} = server.address()
  console.log "Started on #{port}."
