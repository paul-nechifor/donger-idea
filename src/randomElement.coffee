module.exports = ->
  getFace()

getEyes = ->
  doubleIfSingle equalPick [
    '-'
    '.'
    'O'
    '^'
    'o'
    '¯͒'
    'º'
    'ʘ'
    '՞'
    '౦'
    'ಠ'
    'ರ'
    '༎ຶ'
    '•'
    '∗'
    '⊡'
    '▀̿̿'
    '□'
    '◉'
    '◑'
    '◔'
    '◕'
    '◠'
    '◯'
    '☉'
    '＾'
    ['ˊ', 'ˋ']
    ['ᓀ', 'ᓂ']
    ['⋋', '⋌']
    ['◖ ', ' ◗']
    ['◥▶', '◀◤']
  ]

doubleIfSingle = (item) ->
  if typeof item is 'string'
    [item, item]
  else
    item

getFaceWrapper = ->
  doubleIfSingle equalPick [
    ''
    '|'
    ['(', ')']
    ['/', '\\']
    ['[', ']']
    ['ʕ', 'ʔ']
    ['༼', ' ༽']
    ['⁽͑', '⁾̉']
    ['〳', '〵']
  ]

getMidface = ->
  equalPick [
    ' '
    '.'
    '_'
    'v'
    'ڡ'
    'ں'
    'ᗜ'
    '‸'
    '‿'
    '‿‿'
    '∀'
    '◞౪◟'
    '〰'
  ]

getHandTypes = ->
  equalPick [
    'none'
    'outer'
    'left'
    'right'
  ]

getHands = (handType) ->
  doubleIfSingle equalPick {
    'outer': [
      ['<', '>']
      '~'
    ]
    'left': [
      '<'
      '~'
      '¯\\'
      'щ'
      'ԅ'
      'ლ '
      'ᕙ'
      '┌'
      '└'
      '╭'
      'シ'
      'ヽ'
      '＜'
      '＼'
    ]
    'right': [
      '/¯'
      '>'
      '~'
      'ง'
      'ᕗ'
      '⊃'
      '┘'
      '╮'
      '◜'
      '☞'
      'っ'
      'づ'
      'ノ'
      '／'
      '＞'
      '～'
    ]
  }[handType]

getCheecks = ->
  cheeck = equalPick [
    '*'
    ';'
    '='
    '@'
    '҂'
    '๑'
    '∴'
    '╬'
    '✿'
    '❁'
    '；'
    '＠'
    '｡'
  ]
  r = Math.random()
  if r < 0.1
    [cheeck, '']
  else if r < 0.2
    ['', cheeck]
  else if r < 0.3
    [cheeck, cheeck]
  else
    ['', '']

getFace = ->
  center = getEyes().join getMidface()
  [w1, w2] = getFaceWrapper()
  return center if w1 is '' and w2 is ''
  handType = getHandTypes()
  return "#{w1}#{center}#{w2}" if handType is 'none'
  center = getCheecks().join center
  [h1, h2] = getHands handType
  switch handType
    when 'outer' then return "#{h1}#{w1}#{center}#{w2}#{h2}"
    when 'left' then return "#{h1}#{w1}#{center}#{h2}#{w2}"
    when 'right' then return "#{w1}#{h1}#{center}#{w2}#{h2}"
  throw 'not-accounted-for'

equalPick = (list) ->
  list[(Math.random() * list.length) | 0]
