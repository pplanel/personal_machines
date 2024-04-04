# pplanel Personal Machines
# personal_machines

`personal_machines` is a repository that contains configurations and scripts for setting up and managing personal machine environments using Docker, Terraform, and Ansible. This project aims to automate the process of configuring and maintaining development and production environments to ensure consistency and repeatability.

## Repository Structure

- `config/tasks`: Contains task configurations. Latest task: `wrap it up`.
- `docker/tasks`: Docker related tasks and configurations. Latest task: `LGTM`.
- `envs`: Environment configurations. Latest task: `LGTM`.
- `.gitignore`: Specifies intentionally untracked files to ignore.
- `README.md`: Provides information about the project (this file).
- `main.tf`: Main Terraform configuration file. Latest task: `wrap it up`.
- `outputs.tf`: Terraform outputs configuration. Latest task: `wrap it up`.
- `playbook.yml`: Ansible playbook for configuring the machines. Latest task: `wrap it up`.
- `terraform_inventory.py`: Python script to generate Terraform inventory. Latest chore: `spelling`.
- `variable.tf`: Terraform variable definitions. Latest task: `LGTM`.

## Getting Started

To get started with `personal_machines`, ensure you have Terraform and Ansible installed on your machine. 
Then, clone this repository to your local machine:
```bash
git clone https://github.com/yourusername/personal_machines.git
cp envs/sample.tfvars
terraform init
terraform plan
terraform apply
terraform destroy
