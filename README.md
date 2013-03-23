- two REST/JSON services "status" and "location" both returning very basic information for a limited set of dummy phone numbers.
-- status returns carrier (sprint, tmobile,verizon) and locatable (true/false)
-- location returns lat, long, accuracy and time
- two "dummy" servers providing responses to the queries

Running the prototype = doing an automated deployment and test.

How about a small github repository and for the deployment we can fire up an EC2 instance, setup concrete, clone the code from github, execute the "build" and email the results?