#!/bin/bash
cd ./terraform-project
terraform apply -auto-approve

cd ../ansible

# Run Ansible after Terraform applies
ansible-playbook -i ./inventory.gcp.yml ./sb-playbook.yml
