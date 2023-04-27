terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "terraform-machine"

    workspaces {
      name = "getting-started"
    }
  }
}

resource "aws_instance" "server" {
  ami = "ami-06e46074ae430fba6"

  instance_type = "t2.micro"
  count         = 1

  tags = {
    "Name" = "test server"
  }
}
//using count function in 
variable "user_names" {
  description = "IAM users"
  type        = set(string)
  default     = ["user1", "user2", "user3"]
}

# resource "aws_iam_user" "iam_user" {
#   count = length(var.user_names)
#   name  = var.user_names[count.index]

# }
resource "aws_iam_user" "example" {
  for_each = var.user_names
  name = each.value
}