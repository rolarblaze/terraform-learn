# Using a single workspace:
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "terraform-machine"

    workspaces {
      name = "getting-started"
    }
  }
}

resource "aws_instance" "test_server" {
  ami = "ami-06e46074ae430fba6"

  instance_type = "t2.micro"

  tags = {
    "Name" = "test_server"
  }
}