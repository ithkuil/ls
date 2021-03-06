AWS = require 'aws-sdk'
fs = require 'fs'

AWS.config.loadFromPath './credentials.json'

AWS.config.update { region: 'us-east-1' }

ec2 = new AWS.EC2().client

script = fs.readFileSync('./initinstance').toString('base64')

interval = (ms, func) -> setInterval func, ms


showInstanceDetails = (id) ->
  params =
    InstanceIds: [ id ]

  ec2.describeInstances params, (err, data) ->
    console.log '.'
    console.log "Instance data:"
    console.log JSON.stringify(data, null, 4)
    console.log '------'
    ip = data.Reservations[0].Instances?[0].PublicIpAddress
    console.log "Instance public IP: #{ip}"
    console.log "Wait a few minutes for initialization to complete and services to start."
    console.log "You should receive an email when the build is complete."
    console.log "Concrete: http://#{ip}:4567/"
    console.log "Test urls:"
    console.log "http://#{ip}:3003/getcarrier/6195508206"
    console.log "http://#{ip}:3004/locate/6195508206"
    process.exit 0

params =
  ImageId: 'ami-2425bd4d'
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
    console.log "Waiting for boot and initialization.."
    interval 2000, ->
      which =
        InstanceIds: [ data?.Instances?[0].InstanceId ]
      ec2.describeInstanceStatus which, (err, data) ->
        if err?
          console.log 'Error getting instance status.'
          console.log err
        else
          process.stdout.write '.'
          status = data.InstanceStatuses?[0].InstanceState?.Name
          if status is 'running'
            showInstanceDetails which.InstanceIds[0]




