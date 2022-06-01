import boto3

cloudwatch = boto3.client('cloudwatch')
ec2_client = boto3.client('ec2')

def lambda_handler(event,context):
    ip_count = 0
    all_subnet_list = ec2_client.describe_subnets()
    for sn in all_subnet_list['Subnets']:
        if sn['AvailableIpAddressCount']<150:
            print(sn['AvailableIpAddressCount'],sn['SubnetId'])
            ip_count +=1
    print(ip_count)
    repsonse = cloudwatch.put_metric_data(
        MetricData = [
            {
                'MetricName': 'Subnet-Low-IPs',
                'Unit': 'None',
                'Value': ip_count
            },
            ],
            Namespace='Subnet-IP-Unavilability'
        )
    print(repsonse)