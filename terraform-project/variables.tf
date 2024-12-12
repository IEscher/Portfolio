# All the variables have an empty description, requires a string and cannot be null. These variables
# allow to provide dynamic values for the Terraform configuration.

variable "gcp_project_id" {
  description = "Google Cloud Platform project ID (can be can be found under Project information on GCP)"
  type        = string
  nullable    = false
}

variable "gcp_service_account_key_file_path" {
  description = "GCP service account key generated via the IAM & Admin > Service Accounts panel"
  type        = string
  nullable    = false
}

variable "gce_instance_name" {
  description = "Google Compute Engine (GCE) instance name"
  type        = string
  nullable    = false
}

variable "gce_instance_user" {
  description = "SSH user for the GCE instance"
  type        = string
  nullable    = false
}

variable "gce_ssh_pub_key_file_path" {
  description = "Path to the public SSH key file"
  type        = string
  nullable    = false
}

variable "domain_name" {
  description = "Domain name for the portfolio"
  type        = string
  nullable    = false
}