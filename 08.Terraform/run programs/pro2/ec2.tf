#===============================Provide Cloud Provider Info=====================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
#==============================Provide AWS Credentials===========================
provider "aws" {
  region     = "ap-southeast-2"
  access_key = "a"
  secret_key = "sv"
}
#==============================Create EC2 Instance===============================
resource "aws_instance" "Amazon-Linux" {
  ami               = "ami-0146fc9ad419e2cfd"
  instance_type     = "t2.micro"
  vpc_security_group_ids = ["sg-05e5b149f591bc0e9"]
  subnet_id              = "subnet-0309a498b51bb1081"
  monitoring             = false
  key_name          = "Linux-Sydney-keypair"
#  user_data = file("${path.module}/node.sh")
  tags = {
    Name = "Amazon-Linux"
  }
}
