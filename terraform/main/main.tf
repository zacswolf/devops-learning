locals {
  aws_region = "us-east-1"
  instance_ami = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"
  instance_name = "devopslearning"
  cidr_block = "0.0.0.0/0"
}

provider "aws" {
  region = local.aws_region
}

resource "aws_security_group" "allow_http_https" {
  name        = "${local.instance_name}_SG"
  description = "Allow inbound traffic on port 80 and 443"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [local.cidr_block]
  }

  tags = {
    Name = "${local.instance_name}_SG"
  }
}

resource "aws_instance" "my_instance" {
  ami           = local.instance_ami
  instance_type = local.instance_type
  vpc_security_group_ids = [aws_security_group.allow_http_https.id]

  tags = {
    Name = local.instance_name
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../ansible/inventory.ini"
  }
}


resource "aws_eip" "my_eip" {
  vpc      = true
  instance = aws_instance.my_instance.id

  tags = {
    Name = "${local.instance_name}_EIP"
  }
}

output "instance_public_ip" {
  description = "Public IP address of the instance"
  value       = aws_eip.my_eip.public_ip
}
