AWS = require 'aws-sdk'
fs = require 'fs'

AWS.config.loadFromPath './credentials.json'

AWS.config.update { region: 'us-east-1' }

ec2 = new AWS.EC2().client

script = fs.readFileSync('./initinstance').toString('base64')

params =
  ImageId: 'ami-7539b41c'
  MinCount: 1
  MaxCount: 1
  UserData: script
  InstanceType: 't1.micro'
  SecurityGroups: [ 'quicklaunch-0' ]
  KeyName: 'bob1'

ec2.runInstances params, (err, data) ->
  if err?
    console.log 'There was an error launching the instance:'
    console.log err
  else
    console.log "Instance launched:"
    console.log JSON.stringify(data, null, 4)



