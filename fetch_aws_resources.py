#!/usr/bin/env -S uv run --with boto3 --script

import boto3


def fetch_aws_resources():
    # Initialize clients
    ec2 = boto3.client("ec2")
    ssm = boto3.client("ssm")

    # Fetch Default VPC ID
    vpc_id = ""
    vpcs = ec2.describe_vpcs(Filters=[{"Name": "isDefault", "Values": ["true"]}])
    if vpcs["Vpcs"]:
        vpc_id = vpcs["Vpcs"][0]["VpcId"]

    # Fetch Public Subnet ID in the default VPC
    public_subnet_id = ""
    if vpc_id:
        subnets = ec2.describe_subnets(
            Filters=[
                {"Name": "vpc-id", "Values": [vpc_id]},
                {"Name": "map-public-ip-on-launch", "Values": ["true"]},
            ]
        )
        if subnets["Subnets"]:
            public_subnet_id = subnets["Subnets"][0]["SubnetId"]

    # Fetch First Available Key Pair
    keypair = ""
    key_pairs = ec2.describe_key_pairs()
    if key_pairs["KeyPairs"]:
        keypair = key_pairs["KeyPairs"][0]["KeyName"]

    # Fetch Latest Amazon Linux 2 AMI ID
    ami_id = ""
    try:
        ami_param = ssm.get_parameter(
            Name="/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
        )
        ami_id = ami_param["Parameter"]["Value"]
    except Exception as e:
        print(f"Error fetching AMI ID: {e}")

    # Print results
    print(f'vpc_id           = "{vpc_id}"')
    print(f'public_subnet_id = "{public_subnet_id}"')
    print(f'keypair          = "{keypair}"')
    print(f'ami_id           = "{ami_id}"')


if __name__ == "__main__":
    fetch_aws_resources()
