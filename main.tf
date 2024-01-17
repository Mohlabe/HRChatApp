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



# Generating Key pairs
resource "tls_private_key" "rsa_pairs" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

variable "key_name" {}

resource "aws_key_pair" "KeyPair_Deploy" {
  key_name   = var.key_name
  public_key = tls_private_key.rsa_pairs.public_key_openssh
}

resource "local_file" "private_key" {

  content = tls_private_key.rsa_pairs.private_key_pem
  filename = var.key_name

}

resource "aws_security_group" "App_sg" {
  name        = "App_sg"
  vpc_id = "vpc-02884d1aebf7d6bbf"

  ingress {
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
}


resource "aws_instance" "AppServer" {
  count = 2
  ami           = "ami-0e878fcddf2937686"
  instance_type = "t3.micro"
  subnet_id = "subnet-0971000f20d012cd1"
  key_name = aws_key_pair.KeyPair_Deploy.key_name

   tags = {
    Name = "Instance-${count.index + 1}"

  
}
}