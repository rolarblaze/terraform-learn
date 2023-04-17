terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.63.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "test_server" {
  ami = "ami-06e46074ae430fba6"

  instance_type = "t2.micro"

  tags = {
    "Name" = "test_server"
  }
}