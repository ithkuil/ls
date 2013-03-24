AWS = require 'aws-sdk'
fs = require 'fs'

AWS.config.loadFromPath './credentials.json'

AWS.config.update { region: 'us-east-1' }

ec2 = new AWS.EC2().client

ec2.describeInstances (err, data) ->
  for obj in data.Reservations
    for inst in obj.Instances
      if inst.State.Name is 'running'
        console.log inst.PublicIpAddress + '\t\t' + inst.LaunchTime



