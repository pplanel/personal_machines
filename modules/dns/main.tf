terraform {
  required_version = "~> 1.10"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}


data "cloudflare_zone" "cf_zone" {
  filter = {
    name = var.zone_name
  }
}

resource "cloudflare_dns_record" "machine" {
  zone_id = data.cloudflare_zone.cf_zone.zone_id
  name    = var.subdomain
  content = var.public_dns
  type    = "CNAME"
  ttl     = 3600
}
