terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "af-south-1"
}

# Create a VPC
resource "aws_vpc" "HrApp_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "AppContainer1" {
  ami           = "ami-0e878fcddf2937686"
  instance_type = "t3.micro"

   tags = {
    Name = "HrApp"
}
