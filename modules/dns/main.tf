data "cloudflare_zone" "cf_zone" {
  name = var.zone_name
}

resource "cloudflare_record" "machine" {
  zone_id = data.cloudflare_zone.cf_zone.id
  name    = var.subdomain
  value   = var.public_dns
  type    = "CNAME"
}
