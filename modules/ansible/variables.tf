variable "domain" {
  type        = string
  description = "The FQDN of the host"
}

variable "secret_name" {
  type        = string
  description = "The name of the secret in 1Password"
}

variable "vault_name" {
  type        = string
  description = "The name of the 1Password vault"
}
