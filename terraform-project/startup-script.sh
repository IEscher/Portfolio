#!/bin/bash
# Fetch the GCP key from instance metadata
GCP_KEY=$(curl http://metadata.google.internal/computeMetadata/v1/instance/attributes/gcp-key -H "Metadata-Flavor: Google")

# Save the GCP key to a file
echo "$GCP_KEY" > /opt/gcp-key.json

# Install Ansible and prerequisites
apt update && apt install -y ansible

# Install Google Cloud SDK
apt-get install -y apt-transport-https ca-certificates gnupg
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
apt-get install -y google-cloud-sdk

# Authenticate with GCP using the fetched key
gcloud auth activate-service-account --key-file=/opt/gcp-key.json

# Download the Ansible playbook from GCS
gsutil cp gs://tf-portfolio-bucket-iescher/sb-playbook.yml /opt/playbooks/sb-playbook.yml

# Run the playbook
cd /opt/playbooks || return 1
ansible-playbook -i localhost, /opt/playbooks/sb-playbook.yml