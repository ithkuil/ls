express = require 'express'
locator = require './locator'

express = require 'express'
app = express()

app.get '/locate/:phone', (req, res, next) ->
  locator.locate req.query.phone, (info) ->
    res.end JSON.stringify(info)

app.listen 80
console.log 'Listening on port 80'

process.on 'uncaughtException', (err) ->
  console.log err