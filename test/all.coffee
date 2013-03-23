test = require('tap').test

config = require '../config.json'

status = require '../status'
#location = require '../locate'
testData = require '../dummies'

request = require 'request'

console.error "CWD is #{process.cwd()}"

test "LS tests from #{process.cwd()}", (t) ->

  t.test 'status', (t) ->
    for dummy in testData
      status.getCarrier dummy.phone, (statusInfo) ->
        t.equal statusInfo.carrier, dummy.carrier
        t.equal statusInfo.locatable, dummy.locatable
    t.end()

  t.test 'config', (t) ->
    t.ok config.statusHostd
    t.end()

    ###
    t.test 'status service', (t) ->
      for dummy in testData
        request.get
        status.getCarrier dummy.phone (statusInfo) ->
          t.equal statusInfo.carrier, dummy.carrier
          t.equal statusInfo.locatable, dummy.locatable

          t.test 'location', (t) ->
            for dummy in testData
              location.getLocation statusInfo.carrier, dummy.phone (locationInfo ->
                t.equal locationInfo.latitude, dummy.latitude
                t.equal locationInfo.longitude, dummy.longitude
                t.equal locationInfo.accuracy, dummy.accuracy
                t.equal locationInfo.time, dummy.time
            t.end()
    ###
