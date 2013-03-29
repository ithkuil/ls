loc = require './locrequestexample'

loc.locate '6195508206', (data) ->
  console.log 'locate returned: '
  console.log data
