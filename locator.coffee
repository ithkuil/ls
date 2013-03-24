locatorData = require './locatordata.json'

locate = (phone, carrier, callback) ->
  callback locatorData[phone]

exports.locate = locate