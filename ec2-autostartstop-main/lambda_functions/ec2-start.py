import boto3
import os
def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(Filters=[{'Name': os.environ["supertag"], 'Values': ['true']}])
    for reservation in instances.get("Reservations"):
        for instance in reservation.get("Instances"):
            instance_id = instance['InstanceId']
        ec2.start_instances(InstanceIds=[instance_id])
        print('Started_instances: ' + str(instance_id))