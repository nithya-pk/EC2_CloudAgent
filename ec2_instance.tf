# EC2 instance in public subnet2
resource "aws_instance" "apacheserver" {
 ami = "${var.ami_ver}"
 instance_type = "${var.ec2_type}"
 subnet_id = aws_subnet.public_subnets[0].id
 vpc_security_group_ids = [aws_security_group.allow_ssh_tcp.id]
 key_name = var.ssh_key_pair
 associate_public_ip_address = true
 depends_on = [aws_subnet.public_subnets[0]]
 iam_instance_profile = "LabInstanceProfile"
 provisioner "remote-exec" {
  connection {
   type = "ssh"
   user = "ec2-user"
   private_key = file("/Users/nithyakamalanathan/downloads/labsuser.pem")
   host = self.public_ip
  }
  inline = [
   "sudo yum update -y",
   "sudo yum install -y httpd",
   "sudo systemctl start httpd",
   "sudo systemctl enable httpd", 
   
   "sudo yum install -y amazon-cloudwatch-agent",
   "sudo systemctl start amazon-cloudwatch-agent",
   "sudo systemctl enable amazon-cloudwatch-agent",
   "sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF",
   jsonencode({
    "agent": {
     "metrics_collection_interval": 60,
     "run_as_user": "cwagent",
     "debug": false
    },
    "logs": {
     "logs_collected": {
      "files": {
       "collect_list": [
       {
        "file_path": "/var/log/httpd/access_log",
        "log_group_name": "httpd_access_log",
        "log_stream_name": "{instance_id}"
       },
       {
        "file_path": "/var/log/httpd/error_log",
        "log_group_name": "httpd_error_log",
        "log_stream_name": "{instance_id}"
       }
       ]
      }
    },
    "log_stream_name": "{instance_id}",
    "force_flush_interval": 15
   }
   }),
   "EOF",
   "sudo systemctl restart amazon-cloudwatch-agent"
  ]
 } 
 tags = {Name = "apacheserver"}
}

