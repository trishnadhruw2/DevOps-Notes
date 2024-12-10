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
  secret_key = "s"
}
#==============================Create Apache Webserver===============================
resource "aws_instance" "Apache-Webserver" {
  ami               = "ami-0146fc9ad419e2cfd"
  instance_type     = "t2.micro"
  vpc_security_group_ids = ["sg-05e5b149f591bc0e9"]
  subnet_id              = "subnet-0309a498b51bb1081"
  monitoring             = false
  key_name          = "Linux-Sydney-keypair"
  user_data = file("${path.module}/apache.sh")
  tags = {
    Name = "Apache-Webserver"
  }
}
#==============================Create Nginx Webserver===============================
resource "aws_instance" "Nginx-Webserver" {
  ami               = "ami-0146fc9ad419e2cfd"
  instance_type     = "t2.micro"
  vpc_security_group_ids = ["sg-05e5b149f591bc0e9"]
  subnet_id              = "subnet-0309a498b51bb1081"
  monitoring             = false
  key_name          = "Linux-Sydney-keypair"
  user_data = file("${path.module}/nginx.sh")
  tags = {
    Name = "Nginx-Webserver"
  }
}
#==============================Create Docker Container===============================
resource "aws_instance" "Docker-Server" {
  ami               = "ami-0146fc9ad419e2cfd"
  instance_type     = "t2.micro"
  vpc_security_group_ids = ["sg-05e5b149f591bc0e9"]
  subnet_id              = "subnet-0309a498b51bb1081"
  monitoring             = false
  key_name          = "Linux-Sydney-keypair"
  user_data = file("${path.module}/docker.sh")
  tags = {
    Name = "Docker-Server"
  }
}
