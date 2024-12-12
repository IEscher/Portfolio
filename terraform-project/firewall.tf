resource "google_compute_firewall" "default-allow-http" {
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-http"
  network       = "default"
  priority      = "1000"
  project       = "protfolio-444215"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "default-allow-https" {
  allow {
    ports    = ["443"]
    protocol = "tcp"
  }

  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-https"
  network       = "default"
  priority      = "1000"
  project       = "protfolio-444215"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "default-allow-icmp" {
  allow {
    protocol = "icmp"
  }

  description   = "Allow ICMP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-icmp"
  network       = "default"
  priority      = "65534"
  project       = "protfolio-444215"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default-allow-internal" {
  allow {
    ports    = ["0-65535"]
    protocol = "tcp"
  }

  allow {
    ports    = ["0-65535"]
    protocol = "udp"
  }

  allow {
    protocol = "icmp"
  }

  description   = "Allow internal traffic on the default network"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-internal"
  network       = "default"
  priority      = "65534"
  project       = "protfolio-444215"
  source_ranges = ["10.128.0.0/9"]
}

resource "google_compute_firewall" "default-allow-rdp" {
  allow {
    ports    = ["3389"]
    protocol = "tcp"
  }

  description   = "Allow RDP from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-rdp"
  network       = "default"
  priority      = "65534"
  project       = "protfolio-444215"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default-allow-ssh" {
  allow {
    ports    = ["22"]
    protocol = "tcp"
  }

  description   = "Allow SSH from anywhere"
  direction     = "INGRESS"
  disabled      = "false"
  name          = "tf-default-allow-ssh"
  network       = "default"
  priority      = "65534"
  project       = "protfolio-444215"
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "fw_allow_health_check" {
  allow {
    ports    = ["80"]
    protocol = "tcp"
  }

  name          = "tf-fw-allow-health-check"
  direction     = "INGRESS"
  network       = "default"
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["allow-health-check"]
}
