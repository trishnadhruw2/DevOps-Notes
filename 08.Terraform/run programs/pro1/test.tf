terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = "ap-southeast-2"
  access_key = "a"
  secret_key = "s"
}
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
