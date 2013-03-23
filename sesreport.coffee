AmazonSES = require 'amazon-ses'

credentials = require './credentials.json'
ses = new AmazonSES credentials.accessKeyId, credentials.secretAccessKey

#ses.verifyEmailAddress 'ithkuil@gmail.com'

fs = require 'fs'

message = fs.readFileSync('/dev/stdin').toString()

message = message.replace /\n/g, '<br/>'

Convert = require 'ansi-to-html'
convert = new Convert()


html = convert.toHtml message

html = '<div style="padding: 20px; background: #85A0F2;"">' + html + '</div>'

config = require './config.json'

email =
  from:     'ithkuil@gmail.com'
  to:       [ config.sendReportTo ]
  replyTo:  [ 'ithkuil@gmail.com' ]
  subject:  'Build output'
  body:
    text:   message
    html:   html

ses.send email, (err, data) ->
  if err?
    console.log err
  else
    console.log data


