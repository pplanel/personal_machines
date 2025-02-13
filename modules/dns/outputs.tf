output "fqdn" {
  value = cloudflare_dns_record.machine.content
}
