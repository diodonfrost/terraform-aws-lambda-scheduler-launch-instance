"""This script run aws instance resources"""

import os
import logging
import boto3

# Setup simple logging for INFO
LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

# Retrieve variables from Lmanda ENVIRONMENT
ami_id = os.getenv('ami_id', 'ami-07683a44e80cd32c5')
instance_type = os.getenv('instance_type', 't2.micro')
keypair = os.getenv('keypair', 'my-little-key')
security_grp = os.getenv('security_grp', 'my-little-security-group')
user_data = os.getenv('user_data', 'echo test')


def lambda_handler(event, context):
    """ Main function entrypoint for lambda """

    # Define the connection
    ec2 = boto3.client('ec2')

    ec2.run_instances(
        ImageId=ami_id,
        InstanceType=instance_type,
        KeyName=keypair,
        MaxCount=1,
        MinCount=1,
        SecurityGroups=[
            security_grp,
        ],
        UserData=user_data,
    )
