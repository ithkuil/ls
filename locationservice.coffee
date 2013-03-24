express = require 'express'
locator = require './locator'

app = express()
server = null

config = require './config.json'

app.get '/locate/:carrier/:phone', (req, res, next) ->
  locator.locate req.params.phone, req.params.carrier, (info) ->
    res.setHeader 'Content-Type', 'application/json'
    res.end JSON.stringify(info)

start = (callback) ->
  server = app.listen config.locatorPort
  callback?()

shutdown = (callback) ->
  server.close()
  callback?()

args = process.argv.splice 2

if '--run' in args
  console.log "Listening on port #{config.locatorPort}"
  start()
else
  console.log 'To start from command line include option --run'

process.on 'uncaughtException', (err) ->
  console.log err

exports.start = start
exports.shutdown = shutdown
