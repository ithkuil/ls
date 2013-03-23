statusData = require './statusdata.json'

getCarrier = (phone, callback)->
  callback statusData[phone]

exports.getCarrier = getCarrier