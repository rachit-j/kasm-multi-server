provider "aws" {
  region = var.region
}

locals {
  amis = {
    "us-west-1" = "ami-0ff591da048329e00"
    "us-west-2" = "ami-0aff18ec83b712f05"
    "us-east-1" = "ami-0b72821e2f351e396"
    "us-east-2" = "ami-0862be96e41dcbf74"
  }

  agent_ami = lookup(local.amis, var.region, var.custom_ami)
  other_ami = lookup(local.amis, var.region, var.custom_ami)
}

resource "tls_private_key" "deployer" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-${random_id.key_id.hex}"
  public_key = tls_private_key.deployer.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.deployer.private_key_pem
  filename = "${path.module}/deployer-key-${random_id.key_id.hex}.pem"
  file_permission = "0600"
}

resource "random_id" "key_id" {
  byte_length = 4
}

resource "aws_security_group" "kasm_sg" {
  name        = "kasm_sg"
  description = "Security group for Kasm servers"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Replace with YOUR_IP/32 for more security
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "agent_servers" {
  count         = var.agent_server_count
  ami           = local.agent_ami
  instance_type = var.agent_server_size
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.kasm_sg.name]

  root_block_device {
    volume_size = var.agent_server_disk_size
    volume_type = "gp2"
  }

  tags = {
    Name = "kasm-agent-${count.index + 1}"
  }
}

resource "aws_instance" "db_server" {
  ami           = local.other_ami
  instance_type = var.other_server_size
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.kasm_sg.name]

  root_block_device {
    volume_size = var.other_server_disk_size
    volume_type = "gp2"
  }

  tags = {
    Name = "kasm-db"
  }
}

resource "aws_instance" "guac_server" {
  ami           = local.other_ami
  instance_type = var.other_server_size
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.kasm_sg.name]

  root_block_device {
    volume_size = var.other_server_disk_size
    volume_type = "gp2"
  }

  tags = {
    Name = "kasm-guac"
  }
}

resource "aws_instance" "web_server" {
  ami           = local.other_ami
  instance_type = var.other_server_size
  key_name      = aws_key_pair.deployer.key_name
  security_groups = [aws_security_group.kasm_sg.name]

  root_block_device {
    volume_size = var.other_server_disk_size
    volume_type = "gp2"
  }

  tags = {
    Name = "kasm-web"
  }
}

resource "aws_eip" "web_server_eip" {
  instance = aws_instance.web_server.id
}