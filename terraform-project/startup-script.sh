#!/bin/bash
# Install Ansible and prerequisites
apt update && apt install -y ansible git

# Clone playbooks (or pull them from GCS)
git clone https://github.com/your-repo/your-playbooks.git /opt/playbooks

# Run the playbook
cd /opt/playbooks
ansible-playbook -i localhost, sb-playbook.yml
