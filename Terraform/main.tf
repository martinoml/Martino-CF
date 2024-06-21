

provider "aws" {
  region = "us-west-2"  
}

#Create VPC
module "my_vpc" {
  source = "./modules/vpc"

  vpc_cidr_block       = "10.1.0.0/16"
  vpc_name             = "MainVPC"
  igw_name             = "MainIGW"
  public_subnets       = [
    { availability_zone = "us-west-2a" },
    { availability_zone = "us-west-2b" }
  ]
  private_subnets      = [
    { availability_zone = "us-west-2a" },
    { availability_zone = "us-west-2b" }
  ]
}


#Create Security Group
module "securitygroup" {
  source = "./modules/securitygroup"

  sg_name        = "cf_securitygroup"
  sg_description = "My custom security group"
  vpc_id         = "vpc-012148fbcaa7e6deb"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP inbound traffic"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/16"]  
      description = "Allow SSH inbound traffic"
    }
 
  ]
 
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"  
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
   
  ]
}

#Create Load Balancer
module "loadbalancing" {
  source   = "./modules/loadbalancing"
  alb_name = "cf-lb"
  vpc_id   = "vpc-012148fbcaa7e6deb"

  subnets = ["subnet-0921f0fe0bdaed49e", "subnet-0c843483abdbe6db4"]
}

#Create ASG 

module "compute" {
  source = "./modules/compute"
  lc_name            = "my_ASG"
  instance_type      = "t2.micro"
  subnet_ids = ["subnet-0921f0fe0bdaed49e", "subnet-0c843483abdbe6db4"]
  min_size           = 2
  max_size           = 6
  desired_capacity   = 2
  asg_name           = "my-asg"
}


#Create EC2 Instance
data "aws_ami" "redhat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Red Hat Enterprise Linux 8*"]
  }

  owners = ["aws-marketplace"]
}
resource "aws_instance" "cf_ec2instance" {
  ami           = data.aws_ami.redhat.id
  instance_type = "t2.micro"
  subnet_id     = "subnet-0921f0fe0bdaed49e"    

  root_block_device {
    volume_size = 20
     
  }
}
#Create storage bucket
module "storage" {
  source             = "./modules/storage"
  cf_testbucket1 =   "cftestbucket1pls"
  cf_testbucket2 =    "cftestbucket2pls"
}



# Define the IAM policy document
data "aws_iam_policy_document" "s3_write_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]

    resources = [
      "arn:aws:s3:::cf_testbucket2"  
    ]
  }
}

# Create IAM policy attaching the policy document
resource "aws_iam_policy" "ec2_s3_write_policy" {
  name        = "EC2S3WritePolicy"
  description = "Allows EC2 instances to write logs to S3 bucket"
  policy      = data.aws_iam_policy_document.s3_write_policy.json
}

# Create IAM role for EC2 instances
resource "aws_iam_role" "ec2_s3_write_role" {
  name               = "EC2S3WriteRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "EC2S3WriteRole"
  }
}

# Attach IAM policy to IAM role
resource "aws_iam_policy_attachment" "attach_s3_write_policy" {
  name       = "attach-s3-write-policy"
  roles      = [aws_iam_role.ec2_s3_write_role.name]
  policy_arn = aws_iam_policy.ec2_s3_write_policy.arn
}