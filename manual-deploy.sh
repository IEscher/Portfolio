#!/bin/bash

# Evereything in this file is also done with the ./.github/workflows/ci-cd.yml file

# Compile the application
./mvnw clean compile assembly:single

# Upload the jar application to the google bucket
gsutil cp ./portfolio-0.0.1-SNAPSHOT.jar gs://tf-portfolio-bucket-iescher/application.jar

# Upload the ansible playbook to the google bucket for future vm instances created automatically
gsutil cp ./ansible/sb-playbook.yml gs://tf-portfolio-bucket-iescher/sb-playbook.yml

# execute the ansible playbook on all vm instances
cd ./ansible || return 1
ansible-playbook -i ./inventory.gcp.yml ./sb-playbook.yml