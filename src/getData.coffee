_ = require 'lodash'
async = require 'async'
cheerio = require 'cheerio'
fs = require 'fs'
request = require 'request'

website = 'http://dongerlist.com'

getDongersOnPage = (index, cb) ->
  loadPage "#{website}/page/#{index}", (err, $) ->
    return cb err if err
    console.log "Got page #{index}."
    cb null, $('textarea.donger').map(-> $(@).text()).toArray()

getNumberOfPages = (cb) ->
  loadPage website, (err, $) ->
    return cb err if err
    cb null, Number $('.wp-pagenavi .last').text()

loadPage = (url, cb) ->
  request url, (err, res, html) ->
    return cb err if err
    cb null, cheerio.load html

getEmoticons = (cb) ->
  getNumberOfPages (err, nPages) ->
    return cb err if err
    console.log "Number of pages: #{nPages}."
    async.map _.range(1, nPages + 1), getDongersOnPage, (err, lists) ->
      return cb err if err
      console.log "Download done."
      cb null, _.union.apply null, lists

main = (cb) ->
  getEmoticons (err, emoticons) ->
    return cb err if err
    jsonFile =  __dirname + '/../data/emoticons.json'
    fs.writeFile jsonFile, JSON.stringify(emoticons), (err) ->
      return cb err if err
      cb null

main (err) ->
  throw err if err
