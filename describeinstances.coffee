AWS = require 'aws-sdk'
fs = require 'fs'

AWS.config.loadFromPath './credentials.json'

AWS.config.update { region: 'us-east-1' }

ec2 = new AWS.EC2().client

ec2.describeInstances (err, data) ->
  console.log JSON.stringify(data, null, 4)



