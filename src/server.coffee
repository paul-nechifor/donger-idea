_ = require 'lodash'
express = require 'express'
fs = require 'fs'
getRandomElement = require './randomElement'

app = express()
emoticons = JSON.parse fs.readFileSync __dirname + '/../data/emoticons.json'
hugeList = do ->
  dict = JSON.parse fs.readFileSync __dirname + '/../data/kao.json'
  list = []
  collectValues = (dict) ->
    if dict instanceof Array
      list.push.apply list, dict
    else
      for key, value of dict
        collectValues value
  collectValues dict
  list

app.get '/', (req, res) ->
  res.send getPage emoticons

app.get '/random', (req, res) ->
  res.send getPage getRandomList()

app.get '/huge', (req, res) ->
  res.send getPage hugeList

getPage = (list) ->
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
            white-space: pre;
          }
        </style>
      </head>
      <body>
        <div class='list'>
          #{formatList list}
        </div>
      </body>
    </html>
  """

formatList = (list) ->
  _.shuffle list
  .map (x) -> "<div>#{escapeHtml  x}</div>"
  .join ''

server = app.listen Number(process.env.port) or 3000, ->
  {port} = server.address()
  console.log "Started on #{port}."

getRandomList = ->
  for x in [1 .. 500]
    getRandomElement()

escapeHtml = (unsafe) ->
  unsafe
  .replace /&/g, '&amp;'
  .replace /</g, '&lt;'
  .replace />/g, '&gt;'
  .replace /"/g, '&quot;'
  .replace /'/g, '&#039;'
