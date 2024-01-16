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

resource "aws_instance" "AppContainer" {
  ami           = "ami-0e878fcddf2937686"
  instance_type = "t3.micro"

   tags = {
    Name = "HrApp"
}
}

# Create a VPC
resource "aws_vpc" "HrApp_vpc" {
  cidr_block = "10.0.0.0/16"

tags = {
    Name = "HrApp"

}
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.HrApp_vpc.id
  cidr_block        = "172.31.32.0/20"
  availability_zone = "af-south-1"

  tags = {
    Name = "HrApp"
  }
}

resource "aws_network_interface" "Nic11" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.31.32.100"]

  tags = {
    Name = "primary_network_interface"
  }
}