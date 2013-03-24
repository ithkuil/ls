express = require 'express'
locator = require './locator'
status = require './status'

app = express()
server = null

config = require './config.json'

app.get '/locate/:phone', (req, res, next) ->
  status.getCarrier req.params.phone, (status) ->
    if status.locatable
      locator.locate req.params.phone, (info) ->
        res.setHeader 'Content-Type', 'application/json'
        res.end JSON.stringify(info)
    else
      res.setHeader 'Content-Type', 'application/json'
      res.end "false"

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
