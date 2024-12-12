# [START cloudloadbalancing_target_https_proxy_basic]
resource "google_compute_target_https_proxy" "https_lb_proxy" {
  name             = "tf-https-lb-proxy"
  url_map          = google_compute_url_map.url_map.id
  ssl_certificates = [google_compute_ssl_certificate.my_certificate.id]
}

resource "google_compute_target_http_proxy" "http_lb_proxy" {
  name    = "tf-http-lb-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "tls_private_key" "default_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "default_cert" {
  private_key_pem = tls_private_key.default_key.private_key_pem

  # Certificate expires after 12 hours.
  validity_period_hours = 12

  # Generate a new certificate if Terraform is run within three
  # hours of the certificate's expiration time.
  early_renewal_hours = 3

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  dns_names = [var.domain_name]

  subject {
    common_name  = var.domain_name
    organization = ""
  }
}

resource "google_compute_ssl_certificate" "my_certificate" {
  name        = "tf-my-certificate"
  private_key = tls_private_key.default_key.private_key_pem
  certificate = tls_self_signed_cert.default_cert.cert_pem
}

resource "google_compute_url_map" "url_map" {
  name        = "tf-url-map"
  description = "a description"
  default_service = google_compute_backend_service.backend_service.id
  
  host_rule {
    hosts        = [var.domain_name]
    path_matcher = "allpaths"
  }
  
  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.backend_service.id
    
    path_rule {
      paths   = ["/*"]
      service = google_compute_backend_service.backend_service.id
    }
  }
}

resource "google_compute_backend_service" "backend_service" {
  name        = "tf-backend-service"
  port_name   = "http"
  protocol    = "HTTP"
  timeout_sec = 10
  health_checks = [google_compute_http_health_check.http_health_check.id]

  backend {
    group = google_compute_instance_group_manager.portfolio_igm.instance_group
  }
}

resource "google_compute_http_health_check" "http_health_check" {
  name                = "tf-http-health-check"
  request_path       = "/"
  check_interval_sec  = 60
  timeout_sec         = 5
  healthy_threshold   = 3
  unhealthy_threshold = 3
}

resource "google_compute_global_address" "ipv4_address" {
  name = "tf-loadbalancer-ipv4-address"
  ip_version = "IPV4"
}

resource "google_compute_global_address" "ipv6_address" {
  name = "tf-loadbalancer-ipv6-address"
  ip_version = "IPV6"
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule" {
  name       = "tf-https-forwarding-rule"
  target     = google_compute_target_https_proxy.https_lb_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.ipv4_address.address
  ip_protocol = "TCP"
}

resource "google_compute_global_forwarding_rule" "https_forwarding_rule_ipv6" {
  name       = "tf-https-forwarding-rule-ipv6"
  target     = google_compute_target_https_proxy.https_lb_proxy.id
  port_range = "443"
  ip_address = google_compute_global_address.ipv6_address.address
  ip_protocol = "TCP"
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule" {
  name       = "tf-http-forwarding-rule"
  target     = google_compute_target_http_proxy.http_lb_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.ipv4_address.address
  ip_protocol = "TCP"
}

resource "google_compute_global_forwarding_rule" "http_forwarding_rule_ipv6" {
  name       = "tf-http-forwarding-rule-ipv6"
  target     = google_compute_target_http_proxy.http_lb_proxy.id
  port_range = "80"
  ip_address = google_compute_global_address.ipv6_address.address
  ip_protocol = "TCP"
}
# [END cloudloadbalancing_target_https_proxy_basic]