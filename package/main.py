"""This script run aws instance resources"""

import os
import logging
import base64
import boto3
from botocore.exceptions import ClientError

# Setup simple logging for INFO
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# Retrieve variables from Lmanda ENVIRONMENT
ami_id = os.getenv('ami_id', 'ami-07683a44e80cd32c5')
instance_type = os.getenv('instance_type', 't2.micro')
keypair = os.getenv('keypair', 'my-little-key')
sg_ingress = os.getenv('sg_ingress', '22')
user_data = os.getenv('user_data', 'echo test')


def lambda_handler(event, context):
    """ Main function entrypoint for lambda """

    # Define the connection
    ec2 = boto3.client('ec2')

    # Create security group
    try:
        ec2.create_security_group(
            Description='Security group for lambda function',
            GroupName='allow-lambda-instance-create',
        )
    except ClientError as e:
        if e.response['Error']['Code'] == 'InvalidGroup.Duplicate':
            LOGGER.info("sg allow-lambda-instance-create already exist")
        else:
            print("Unexpected error: %s" % e)

    # Create ingress rules for security group
    for ingress_port in sg_ingress.split(','):
        try:
            ec2.authorize_security_group_ingress(
                CidrIp='0.0.0.0/0',
                FromPort=int(ingress_port),
                GroupName='allow-lambda-instance-create',
                ToPort=int(ingress_port),
                IpProtocol='tcp',
            )
        except ClientError as e:
            if e.response['Error']['Code'] == 'InvalidPermission.Duplicate':
                LOGGER.info(
                  "ingress rule with port %s is already present", ingress_port)
            else:
                print("Unexpected error: %s" % e)

    # Create ec2 instance
    ec2.run_instances(
        ImageId=ami_id,
        InstanceType=instance_type,
        KeyName=keypair,
        MaxCount=1,
        MinCount=1,
        SecurityGroups=[
            'allow-lambda-instance-create',
        ],
        UserData=base64.b64decode(user_data),
    )
