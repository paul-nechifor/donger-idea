_ = require 'lodash'
async = require 'async'
cheerio = require 'cheerio'
fs = require 'fs'
request = require 'request'

website = 'http://japaneseemoticons.me'

loadPage = (url, cb) ->
  request url, (err, res, html) ->
    return cb err if err
    cb null, cheerio.load html

collectMenuItems = ($, map, items) ->
  items.each ->
    el = $ @
    a = el.children 'a'
    name = a.text()
    href = a.attr 'href'
    if href is '#'
      innerMap = {}
      collectMenuItems $, innerMap, el.children('ul').children()
      if Object.keys(innerMap).length > 0
        map[name] = innerMap
    else if href.indexOf(website) is 0
      map[name] = href
    return

getMenu = (cb) ->
  loadPage website, (err, $) ->
    return cb err if err
    map = {}
    collectMenuItems $, map, $ '#menu-main-menu > li'
    cb null, map

convertKeyStructureToList = (obj, list, keyList) ->
  for key, value of obj
    newKeyList = keyList.concat key
    if typeof(value) is 'string'
      list.push [newKeyList, value]
    else
      convertKeyStructureToList value, list, newKeyList
  return

filterOutBadOnes = (array) ->
  _.uniq(array).filter((x) -> x and x.length <= 100).sort()

getEmoticons = ($, tables) ->
  map = {}
  tables.each ->
    table = $ @
    title = table.prevAll('h3').first().text()
    map[title] = filterOutBadOnes table.find('td').map(-> $(@).text()).toArray()
  map

getEmoticonsOnPage = (page, cb) ->
  [clasification, url] = page
  loadPage url, (err, $) ->
    return cb err if err
    tables = $ '.entry-content > table'
    cb null, [clasification, getEmoticons $, tables]

unifyMap = (list) ->
  map = {}
  for [clasification, tables] in list
    innerMap = map
    for part, i in clasification
      if i is clasification.length - 1
        innerMap[part] = tables
      else if innerMap[part]
        innerMap = innerMap[part]
      else
        innerMap = innerMap[part] = {}
  map

main = (cb) ->
  getMenu (err, menu) ->
    return cb err if err
    list = []
    convertKeyStructureToList menu, list, []
    async.map list, getEmoticonsOnPage, (err, results) ->
      return cb err if err
      unifiedMap = unifyMap results
      jsonFile =  __dirname + '/../data/kao.json'
      fs.writeFile jsonFile, JSON.stringify(unifiedMap, null, 2), (err) ->
        return cb err if err
        cb null

main (err) ->
  throw err if err
