import boto3
client = boto3.client ('ec2')
response = client.stop_instances(
    InstanceIds=['i-08d62c28e4f263fa4']
)