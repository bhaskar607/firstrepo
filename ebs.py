import boto3
client = boto3.client('ec2')
response = client.create_volume(
    AvailabilityZone='us-east-1a',
    
    Encrypted=True,
   
    Iops=3000,
    Size=30,
    VolumeType='gp3',
    
    
)