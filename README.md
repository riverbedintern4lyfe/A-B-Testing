# A-B-Testing


# The scripts and files in this folder help make A/B testing for Overstack traffic easier. 
# If you would like to turn on "testing mode" (divert all traffic from a controller exept for yours),
# it is easy to do! All you need to do is run launch_tester.sh and pass your IP address and the IP address 
# of the server you want to test on, with the form 192.168.0.X, as a perameter so that
# it can be added to a whitelist.

# When trying to acess the "testing controller" you need to use jack D of the ethernet or RVBD wifi. 
# Or else the your IP will be changed before connecting to HAProxy due to petfood services and your
# traffic will also be diverted from the testing controller. 

# If you would like to turn off "testing mode" manually, run stop_test_master.sh, which is found in the 
# subprocesses folder, and again pass your IP adress so that it can be removed from the whitelist.

# If you forget to turn off "testing mode" no worries! You IP will be removed from the whitelist
# at the top of the hour 30 min since you began testing.
