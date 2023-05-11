resource "aws_vpc" "server_vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  assign_generated_ipv6_cidr_block = true

}

// creating an Internet gateway to connect to our vpc 

resource "aws_internet_gateway" "server_gw" {
  vpc_id = aws_vpc.server_vpc.id

  tags = {
    Name = "terraformVPC"
  }  
}

//creating a pub subnet 

resource "aws_subnet" "pub_subnet" {
  vpc_id = aws_vpc.server_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public subnet"
  }
}

resource "aws_route_table" "serverRT" {
  vpc_id = aws_vpc.server_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.server_gw.id
  }
  tags = {
    Name = "route table "
  }
}

// creating a route table association 
resource "aws_route_table_association" "pub_subnet_RT_assoc" {
  subnet_id      = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.serverRT.id 
}

//creating a private subnet 
resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.server_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Public subnet"
  }
}
resource "aws_instance" "web" {
  ami = var.ami_id
  instance_type = var.instance_type
  # user_data = <<-EOF
  #               !#bin/bash 
  #               echo "Hello, World!" > index.html
  #               nohup busybox httpd -f -p 8080 &
  #               EOF

  // using file function to update user data in terraform 
  user_data = file("httpd.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "Test server"
  }
}

resource "aws_security_group" "example" {
  name        = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = var.ingress_port
    to_port     = var.ingress_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = var.egress_port
    to_port = var.egress_port
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// creating a user with for each loop
resource "aws_iam_user" "example"{
  for_each = toset(["james", "Willock", "Odegard"])

  name = each.key

  tags = {
    Role = "Sysadmin"
    Project = "Alpha" 
  }
}

// creating multiples s3 bucket using for_each built in function

// in this case we create a bucket for Dev, prod and quality assurance
resource "aws_s3_bucket" "bucket" {
  for_each = {
    my-tf-development = "devdemo"
    my-tf-production = "devDemo"
    my-tf-quality-assurance = "DevDemo"
  }
  bucket = each.key

  tags = {
    Name = each.key
    Environment = each.value
  }

}