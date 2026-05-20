import boto3
import os


def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    instances = ec2.describe_instances(
        Filters=[{'Name': os.environ["supertag"], 'Values': [os.environ["tagvalue"]]}]
    )
    instance_ids = [
        instance['InstanceId']
        for reservation in instances.get("Reservations", [])
        for instance in reservation.get("Instances", [])
    ]

    if instance_ids:
        ec2.stop_instances(InstanceIds=instance_ids)

    print('Stopped_instances: ' + str(instance_ids))
