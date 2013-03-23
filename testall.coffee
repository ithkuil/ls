config = require './config.json'

status = require './status'
#location = require '../locate'
testData = require './dummies'

request = require 'request'
async = require 'async'

statusService = null

e = exports

e.status = (t) ->
  for dummy in testData
    status.getCarrier dummy.phone, (statusInfo) ->
      t.equal statusInfo.carrier, dummy.carrier
      t.equal statusInfo.locatable, dummy.locatable
  t.done()

e.config = (t) ->
  t.ok config.statusBase
  t.ok config.statusPort
  t.done()

e.testData = (t) ->
  t.ok testData
  t.ok (testData.length>0)
  t.done()

e.startStatusService = (t) ->
    statusService = require './statusservice'
    statusService.start ->
      t.done()
    return

e.statusServiceRunning = (t) ->
  request.get "#{config.statusBase}", (err, res, body) ->
    t.equal res.statusCode, 404
    t.done()
  return

carrierRequest = (data, callback) ->
  request.get "#{config.statusBase}/getcarrier/#{data.phone}", (err, res, body) ->
    callback err, { data, body, code: res.statusCode, headers: res.headers }

e.getCarrier = (t) ->
    async.map testData, carrierRequest, (err, results) ->
      for obj in results
        { data, body, headers, code } = obj
        t.ok body, 'body is defined'
        try
          info = JSON.parse body
        t.ok info?, body
        t.equal code, 200
        t.equal headers['content-type'], 'application/json'
        t.ok info.carrier, 'info.carrier defined'
        t.equal info.carrier, data.carrier, 'carrier matches'
        t.equal info.locatable, data.locatable, 'locatable matches'
      t.done()

    return

e.stopStatusService = (t) ->
  statusService.shutdown()
  t.done()
