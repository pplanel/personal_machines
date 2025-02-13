variable "zone_name" {
  type        = string
  description = "The Cloudflare zone name"
}

variable "subdomain" {
  type        = string
  description = "The subdomain to create"
}

variable "public_dns" {
  type        = string
  description = "The public DNS name to point to"
}

variable "cf_api" {
  type = string

}
