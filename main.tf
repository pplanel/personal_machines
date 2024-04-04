terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.35.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.28.0"
    }
  }
}

provider "cloudflare" {
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "my_keypair" {
  public_key = file("~/.ssh/id_rsa.pub")
}

data "cloudflare_zone" "pplanel_dev" {
  name = "pplanel.dev"
}

resource "cloudflare_record" "machine" {
  zone_id = data.cloudflare_zone.pplanel_dev.id
  name    = "machine"
  value   = aws_instance.server01.public_dns
  type    = "CNAME"
}

resource "aws_instance" "server01" {
  ami           = var.ami_id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.my_keypair.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.permitir_ssh_http.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size           = "80"
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = "200"
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = false
  }
}

resource "aws_security_group" "permitir_ssh_http" {
  name        = "permitir_ssh"
  description = "Permite SSH e HTTP na instancia EC2"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH to EC2"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP to EC2"
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

  tags = {
    Name = "permitir_ssh_e_http"
  }
}
