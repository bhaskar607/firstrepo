import boto3
client = boto3.client ('ec2')
response = client.start_instances(
    InstanceIds=['i-08d62c28e4f263fa4']
)