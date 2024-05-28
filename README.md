# EC2-AutoStartStop
This projects creates all the resources in order to be able to start/stop automatically an ec2 instance via a predefined tag & cron schedule

# To execute this repo 
terraform apply -include-file=autostart.tfvars

# How it works
It creates and IAM role 2 eventbridge rules and 2 lambda functions to start/stop instances

# How to make it work
Edit variables on "autostart.tfvars" there you can specify your aws account-name, your region, and the cron schedules.

## ec2 tags
We need to input this tag onto ec2-instance in order to work,  the value should always be "true"
tag = auto-start-stop
value = true 
auto-start-stop = "true"

## ec2 change tag
To modify the tag we want to target we go to autostart.tfvars = supertag ex: we must change this variable this part in order to define which tag we must read ex: "tag:changethis"
