# pplanel Personal Machines

`personal_machines` is a repository that contains configurations and scripts for setting up and managing personal machine environments using Terraform and Ansible. This project aims to automate the process of configuring and maintaining development and production environments to ensure consistency and repeatability.

## Getting Started

To get started with `personal_machines`, ensure you have Terraform and Ansible installed on your machine. 
Then, clone this repository to your local machine:
```bash
git clone https://github.com/yourusername/personal_machines.git
cp envs/sample.tfvars envs/aws.tfvars

vim envs/aws.tfvars

# Install Ansible dependencies
ansible-galaxy install -r requirements.yml

# Bootstrap TF
terraform init
terraform plan
terraform apply

# Apply playbook
ansible-playbook -i inventory.yml playbook.yml

# Destroy
terraform destroy

