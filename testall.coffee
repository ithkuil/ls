config = require './config.json'

status = require './status'
locator = require './locator'
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

e.locate = (t) ->
  for dummy in testData
    locator.locate dummy.phone, dummy.carrier, (location) ->
      t.equal location.lat, dummy.lat
      t.equal location.lon, dummy.lon
      t.equal location.accuracy, dummy.accuracy
      t.equal location.time, dummy.time
  t.done()

e.statusAndLocate = (t) ->
  for dummy in testData
    status.getCarrier dummy.phone, (statusInfo) ->
      if statusInfo.locatable
        locator.locate dummy.phone, statusInfo.carrier, (location) ->
          t.equal location.lat, dummy.lat, 'lat match'
          t.equal location.lon, dummy.lon, 'lon match'
          t.equal location.accuracy, dummy.accuracy, 'accuracy match'
          t.equal location.time, dummy.time, 'time match'
      else
        t.equal false, dummy.locatable, 'locatable match'
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

e.startLocationService = (t) ->
  locationService = require './locationservice'
  locationService.start ->
    t.done()
  return

e.locationServiceRunning = (t) ->
  request.get "#{config.locatorBase}", (err, res, body) ->
    t.ok not err?, err
    t.equal res.statusCode, 404, err
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

locatorRequest = (data, callback) ->
  request.get "#{config.locatorBase}/locate/#{data.carrier}/#{data.phone}", (err, res, body) ->
    callback err, { data, body, code: res?.statusCode, headers: res?.headers }

e.locator = (t) ->
  async.map testData, locatorRequest, (err, results) ->
    t.ok not err?, err
    if err? then console.log err
    for obj in results
      if not obj?
        console.error 'error obj not defined'
      t.ok obj?, 'obj defined'
      { data, body, headers, code } = obj
      t.ok body, 'body is defined'
      try
        info = JSON.parse body
      t.ok info?, body
      t.equal code, 200
      t.equal headers['content-type'], 'application/json'
      t.equal info.lat, data.lat, 'lat matches'
      t.equal info.lon, data.lon, 'lon matches'
      t.equal info.accuracy, data.accuracy, 'accuracy matches'
      t.equal info.time, data.time, 'time matches'
    t.done()
  return


e.stopStatusService = (t) ->
  statusService.shutdown()
  t.done()
