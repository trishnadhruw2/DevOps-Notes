Manage VPC service
=====================================================================================
Step1: write program for provider

#vim  provider.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "ap-southeast-1"
  access_key = "a"
  secret_key = "b"
}
:wq
-----------------------------------------------------------------------------------------------------------------------
Step2: write program for manage vpc
#vim   vpcmgnt.tf

## 1. Create vpc =======================================
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc"
  }
}
##Create Subnet =========================================
resource "aws_subnet" "dev-subnet" {
  vpc_id            = aws_vpc.dev-vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-southeast-1a"
  tags = {
    Name = "dev-subnet"
  }
}
## create igw ============================================
resource "aws_internet_gateway" "dev-igw" {
  vpc_id = aws_vpc.dev-vpc.id
  tags = {
        Name = "dev-igw"
    }
}
##Create Custom Route Table ========================================
resource "aws_route_table" "dev-route-table" {
  vpc_id = aws_vpc.dev-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev-igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.dev-igw.id
  }

  tags = {
    Name = "dev-route-table"
  }
}
##Associate subnet with Route Table ======================================
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.dev-subnet.id
  route_table_id = aws_route_table.dev-route-table.id
}
## Create Security Group =====================================================
resource "aws_security_group" "allow-web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.dev-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
      }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "allow-web"
  }
}
## Create AMI server ======================================================================
resource "aws_instance" "apache-server" {
  ami               = "ami-0f935a2ecd3a7bd5c"
  instance_type     = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow-web.id]
  subnet_id              = aws_subnet.dev-subnet.id
  monitoring             = false
  key_name          = "Linux-Singapore-Keypair-2024"
  user_data = file("${path.module}/apache.sh")
  tags = {
    Name = "apache-server"
  }
}



:wq


----------------------------------------------------------------------------------------------------------------
Step3: Create Script file
now create script file to submit in useradata field ( bootstrapping process )

#vim  apache.sh

#!/bin/bash
yum update -y
yum install wget unzip httpd -y
systemctl start httpd
systemctl enable httpd
wget https://www.free-css.com/assets/files/free-css-templates/download/page290/restoran.zip
unzip restoran.zip
cp -rvf bootstrap-restaurant-template/*  /var/www/html/

:wq
---------------------------------------------------------------------------------------------------
Step4: Initialize and run program

#terraform init
#terraform validate
#terraform plan
#terraform apply
---------------------------------------------------------------------------------------------------
Step5: destroy create resources

#terraform destroy