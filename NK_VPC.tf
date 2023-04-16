# VPC named "NK_VPC" with CIDR mentioned in tfvars file
resource "aws_vpc" "NK_VPC" {
 cidr_block = var.NK_VPC_cidr
 instance_tenancy = "default"
 tags = {Name = "NK_VPC"}
}

# Internet Gateway and attach it to NK_VPC
resource "aws_internet_gateway" "IGW" {
 vpc_id =  aws_vpc.NK_VPC.id
 tags = {Name = "NK_VPC_IGW"}
}

# public subnets with CIDRs mentioned in vars file
resource "aws_subnet" "public_subnets" {
 count = length(var.public_subnets)
 vpc_id =  aws_vpc.NK_VPC.id
 cidr_block = element(var.public_subnets, count.index)
 availability_zone = element(var.az, count.index)
 tags = {Name = "NK_VPC_PubSub${count.index + 1}"}
}

# Route table for publicsubnets. Traffic from public subnets reaches internet via IGW
resource "aws_route_table" "PublicRT" {
 vpc_id =  aws_vpc.NK_VPC.id
  route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.IGW.id
  }
 tags = {Name = "NK_VPC_PublicRT"} 
}

# Route table association with publicsubnets
resource "aws_route_table_association" "PublicRTassociation" {
 count = length(var.public_subnets)
 subnet_id = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.PublicRT.id
}
