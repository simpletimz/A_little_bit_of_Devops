# input variables (things you might want to change without editing the resource code itself)

variable "aws_region" {
    description = "AWS region to deploy into"
    type = string
    default = "us-east-1"
}

variable "instance_type" {
    description = "EC2 instance type (t3_micro is free tier)"
    type = string
    default = "t3.micro"
}

variable "key_name" {
    description = "Name of the AWS key pair for SSH access"
    type = string
}

variable "my_ip" {
    description = "my public ip, for for restricting SSH access"
    type = string
}