You will need to install CoffeeScript and Node.js to run this.  Let me know if you want help with that or there is another issue getting it set up.

Then run

    npm install

to install the modules and

    coffee deployone.coffee

to deploy an instance.  A few minutes later you should get an email (if you are listed in config.json) and then clicking on the test/Concrete links at the end of the shell output should work.

They are micro instances, but maybe best not to deploy too many because then I will get a bill from Amazon. heh.

NOTE: There is a bug in Concrete where the first time you load the page up the styles don't load.  You just need to refresh the page the first time.

- two REST/JSON services "status" and "location" both returning very basic information for a limited set of dummy phone numbers.
-- status returns carrier (sprint, tmobile,verizon) and locatable (true/false)
-- location returns lat, long, accuracy and time
- two "dummy" servers providing responses to the queries

Running the prototype = doing an automated deployment and test.

How about a small github repository and for the deployment we can fire up an EC2 instance, setup concrete, clone the code from github, execute the "build" and email the results?