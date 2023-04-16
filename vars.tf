variable "NK_VPC_cidr" {
 type = string
 description = "CIDR for VPC"
 default = "10.0.0.0/16"
}

variable "az" {
 type = list(string)
 description = "Availability Zone1"
 default     = ["us-west-2a", "us-west-2b"]
}

variable "public_subnets" {
 type = list(string)
 description = "CIDRs of Public Subnets"
 default = ["10.0.0.0/24"]
}

variable "ami_ver" {
 type = string
 description = "Version for EC2 AMI"
 default = "ami-0df24e148fdb9f1d8"
}

variable "ec2_type" {
 type = string
 description = "Tier for EC2"  
 default = "t3.micro"
}

variable "ssh_key_pair" {
 type        = string
 description = "SSH key pair to be provisioned on the instance"
 default     = "vockey"
}
