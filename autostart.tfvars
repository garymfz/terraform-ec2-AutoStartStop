#specify the account-name + region in which the repo is deployed##
accountname = "youraccountname"                                  
region = "yourregion"                                         
#modify this variable to specify the time in which the ec2 starts/stop UTC TIME
cronstart = "cron(25 06 ? * MON-FRI *)" #Starts monday-friday at 06:25 AM UTC
cronstop = "cron(00 22 ? * MON-FRI *)" #Stops monday-friday at 22:00 AM UTC
#if we want to modify the ec2instance tag it should look like these : "tag:changethis"
supertag = "tag:auto-start-stop"

