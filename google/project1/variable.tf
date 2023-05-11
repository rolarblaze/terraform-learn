variable "instance_type"{
    type = string
    default = "t2.micro"
    description = "description"
}

variable "ami_id" {
    type = string
    default = "ami-087de15a22879b9ef"
    description = "ami id "
}

variable "ingress_port" {
    type        = number
    description = "The port number to allow ingress traffic"
    default     = 8080
}

variable "egress_port" {
    type = number
    description = "the port number to allow outgoing traffic"
    default = 0
}