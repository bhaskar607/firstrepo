import boto3
client = boto3.client('iam')
response = client.list_users(
    MaxItems=123
)
print (response)