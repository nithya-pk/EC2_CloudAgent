output "VPCName" {
 value = aws_vpc.NK_VPC.id
 description = "Name of the VPC"
}

output "EC2Instance" {
 value = aws_instance.apacheserver.id
 description = "Name of Apache Server"
}

output "ApacheServerIP" {
 value = aws_instance.apacheserver.public_ip
 description = "Apache Server IP Address"
}

