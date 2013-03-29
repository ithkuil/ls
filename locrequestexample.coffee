lookup = require './lookup'
subscriptions = require './subscriptions'
coder = require './coder'
poi = require './poi'
cross = require './cross'
async = require 'async'

process = (data) ->
  data


locate = (phone, callback) ->
  lookup.search phone, (carrierData) =>
    carrier = require "./#{carrierData.module}"
    carrier.queryLocation phone, (location) ->
      calls =
        subscriptions:  (cb) -> subscriptions.relevant phone, (res) -> cb null, res; return
        addresss:       (cb) -> coder.geocode location,       (res) -> cb null, res; return
        pois:           (cb) -> poi.nearby location,          (res) -> cb null, res; return
        cross:          (cb) -> cross.near location,          (res) -> cb null, res; return
      async.parallel calls, (err, results) ->
        results.carrier = carrierData.module
        results.location = location
        callback process(results)

exports.locate = locate
