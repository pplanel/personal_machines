terraform {
  required_version = "~> 1.10"
  required_providers {
    ansible = {
      source  = "ansible/ansible"
      version = "1.3.0"
    }
  }
}

resource "ansible_host" "host" {
  name   = var.domain
  groups = ["all"]

  variables = {
    ansible_user                 = "ec2-user"
    ansible_ssh_private_key_file = "{{ lookup('community.general.onepassword', '${var.secret_name}', field='private_key', vault='${var.vault_name}') }}"
  }

  provider = ansible
}
