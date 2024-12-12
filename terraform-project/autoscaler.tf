# [START compute_autoscaler_instance_group_parent_tag]
# [START compute_autoscale_schedule]
resource "google_compute_autoscaler" "portfolio_autoscaler" {
  provider = google
  name     = "tf-portfolio-autoscaler"
  zone     = "europe-west6-a"
  target   = google_compute_instance_group_manager.portfolio_igm.id

  autoscaling_policy {
    cpu_utilization {
      predictive_method = "NONE"
      target            = "0.6"
    }

    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60
  }
}
# [END compute_autoscale_schedule]

resource "google_compute_instance_template" "portfolio_instance_template" {
  name           = "tf-portfolio-instance-template"
  machine_type   = "e2-small"
  can_ip_forward = false

  disk {
    source_image = data.google_compute_image.ubuntu_2404_lts.id
  }

  network_interface {
    network = "default"

    access_config {
      network_tier = "PREMIUM"
    }
  }

  tags = ["http-server", "https-server", "lb-health-check"]

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_instance_group_manager" "portfolio_igm" {
  name = "tf-portfolio-igm"
  zone = "europe-west6-a"

  version {
    instance_template = google_compute_instance_template.portfolio_instance_template.id
    name              = "primary"
  }

  base_instance_name = "autoscaler-sample"

  named_port {
    name = "http"
    port = 80
  }
}

data "google_compute_image" "ubuntu_2404_lts" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}
# [END compute_autoscaler_instance_group_parent_tag]