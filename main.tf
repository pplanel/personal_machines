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
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

locals {
  domain = "${var.subdomain}.${var.zone_name}"
}

provider "cloudflare" {
  api_token = var.cf_api
}

provider "aws" {
  region = "us-east-1"
}

data "aws_key_pair" "pplanel" {
  key_name = var.keypair
}

data "cloudflare_zone" "cf_zone" {
  name = var.zone_name
}

resource "aws_key_pair" "new_kp" {
  key_name   = "general_kp"
  public_key = var.public_key
}

resource "cloudflare_record" "machine" {
  zone_id = data.cloudflare_zone.cf_zone.id
  name    = var.subdomain
  value   = aws_instance.server01.public_dns
  type    = "CNAME"
}

resource "aws_instance" "server01" {
  ami           = var.ami_id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.new_kp.key_name
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_http.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name

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

resource "ansible_host" "host" {
  name   = local.domain
  groups = ["all"]

  variables = {
    ansible_user                 = "ubuntu"
    ansible_ssh_private_key_file = "{{ lookup('community.general.onepassword', '${var.secret_name}', field='private_key', vault='${var.vault_name}') }}"
  }
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "ssm_instance_profile"
  role = aws_iam_role.ssm_iam_role.name
}

resource "aws_iam_role_policy_attachment" "ssm_iam_role_policy_attachment" {
  role       = aws_iam_role.ssm_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "ssm_iam_role" {
  name = "ssm_iam_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh"
  description = "Allow SSH and in EC2 instace"
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

  ingress {
    description = "HTTPS to EC2"
    from_port   = 443
    to_port     = 443
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
    Name = "allow_ssh_http"
  }
}
