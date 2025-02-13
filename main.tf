terraform {
  required_version = "~> 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.86.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
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


provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  api_token = var.cf_api

}

resource "aws_key_pair" "new_kp" {
  key_name   = "general_kp"
  public_key = var.public_key
}

module "compute" {
  source = "./modules/compute"

  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_pair_name    = aws_key_pair.new_kp.key_name
  public_subnet_id = var.public_subnet_id
  vpc_id           = var.vpc_id
}

module "storage" {
  source = "./modules/storage"

  availability_zone = module.compute.availability_zone
  instance_id       = module.compute.instance_id
}

module "dns" {
  source = "./modules/dns"

  zone_name  = var.zone_name
  subdomain  = var.subdomain
  public_dns = module.compute.public_dns
  cf_api     = var.cf_api

}

module "ansible" {
  source = "./modules/ansible"

  domain      = local.domain
  secret_name = var.secret_name
  vault_name  = var.vault_name
}
