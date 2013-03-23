express = require 'express'
status = require './status'

app = express()
server = null

config = require './config.json'

app.get '/getcarrier/:phone', (req, res, next) ->
  status.getCarrier req.params.phone, (info) ->
    res.setHeader 'Content-Type', 'application/json'
    res.end JSON.stringify(info)

start = (callback) ->
  server = app.listen config.statusPort
  callback?()

shutdown = (callback) ->
  server.close()
  callback?()

args = process.argv.splice 2

if '--run' in args
  console.log "Listening on port #{config.statusPort}"
  start()
else
  console.log 'To start from command line include option --run'

process.on 'uncaughtException', (err) ->
  console.log err

exports.start = start
exports.shutdown = shutdown
