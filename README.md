# Portfolio
My portfolio website

## Terraform

### Structure

TODO

Note on ssl certificate: sometimes the following error occurs when applying terraform config:

´´´txt
Error: Error when reading or editing SslCertificate: googleapi: Error 400: The ssl_certificate resource 'projects/protfolio-444215/global/sslCertificates/tf-my-certificate' is already being used by 'projects/protfolio-444215/global/targetHttpsProxies/tf-https-lb-proxy', resourceInUseByAnotherResource
´´´

It is because terraform is trying to recreate the certificate but google prevents it since it is already in use. An issue has already been made on Terraform's github.

The workaround I use is to manually create a "Google-managed certificate" on the cloud console and to replace the Terraform created certificate with this one. Terraform will then replace it again with his own.

## Ansible

TODO