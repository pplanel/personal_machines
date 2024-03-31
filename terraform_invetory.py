#!/usr/bin/env python3

import json
import subprocess
from typing import Any

def get_terraform_output():
    cmd = "terraform output -json"
    output = subprocess.check_output(cmd, shell=True)
    return json.loads(output)

def generate_inventory():
    terraform_output = get_terraform_output()
    inventory: dict[str, dict[Any, Any]] = {
        "_meta": {
            "hostvars": {}
        }
    }

    # for key, value in terraform_output.items():
    key = "aws_instances"
    key_pair = terraform_output["key_pair_name"]["value"]
    inventory[key] = {
        "hosts": [terraform_output[key]["value"]],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_ssh_private_key_file": f"~/.ssh/{key_pair}.pem"
        }
    }

    return json.dumps(inventory, indent=2)

if __name__ == "__main__":
    print(generate_inventory())

