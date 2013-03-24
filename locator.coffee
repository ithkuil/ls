locatorData = require './locatordata.json'
status = require './status'

locate = (phone, callback) ->
  status.getCarrier phone, (status) ->
    if status.locatable
      callback locatorData[phone]
    else
      callback undefined

exports.locate = locate