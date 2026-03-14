locals {
  labels     = merge({ managed-by = "terraform" }, var.labels)
  ip_address = var.ip_address != "" ? var.ip_address : null
}

# ---------------------------------------------------------------------------
# Regional Health Check
# INTERNAL_MANAGED requires regional health checks (not global).
# ---------------------------------------------------------------------------

resource "google_compute_region_health_check" "main" {
  name                = "${var.name}-health-check"
  project             = var.project_id
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = var.health_check_port
    request_path = var.health_check_request_path
  }
}

# ---------------------------------------------------------------------------
# Firewall rule – allow GCP health check probers to reach backends
# ---------------------------------------------------------------------------

resource "google_compute_firewall" "health_check" {
  name    = "${var.name}-allow-health-check"
  project = var.project_id
  network = var.network

  source_ranges = var.health_check_source_ranges

  allow {
    protocol = "tcp"
    ports    = [tostring(var.health_check_port)]
  }

  target_tags = ["${var.name}-backend"]
}

# ---------------------------------------------------------------------------
# Firewall rule – allow the proxy-only subnet to reach backends
# Envoy proxies in the proxy-only subnet forward requests to backends.
# ---------------------------------------------------------------------------

resource "google_compute_firewall" "allow_proxy" {
  name    = "${var.name}-allow-proxy"
  project = var.project_id
  network = var.network

  source_ranges = [var.proxy_subnet_cidr]

  allow {
    protocol = "tcp"
    ports    = ["80", "443", tostring(var.health_check_port)]
  }

  target_tags = ["${var.name}-backend"]
}

# ---------------------------------------------------------------------------
# Regional SSL Certificate
# Google-managed certificates are not supported for internal HTTPS LBs.
# Supply your own PEM-encoded certificate and private key.
# ---------------------------------------------------------------------------

resource "google_compute_region_ssl_certificate" "main" {
  name        = "${var.name}-ssl-cert"
  project     = var.project_id
  region      = var.region
  certificate = var.ssl_certificate
  private_key = var.ssl_private_key

  lifecycle {
    create_before_destroy = true
  }
}

# ---------------------------------------------------------------------------
# Regional Backend Service
# ---------------------------------------------------------------------------

resource "google_compute_region_backend_service" "main" {
  name                  = "${var.name}-backend-service"
  project               = var.project_id
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  health_checks         = [google_compute_region_health_check.main.id]

  dynamic "backend" {
    for_each = var.backends

    content {
      group                 = backend.value.group
      description           = backend.value.description
      balancing_mode        = backend.value.balancing_mode
      capacity_scaler       = backend.value.capacity_scaler
      max_rate_per_instance = backend.value.max_rate_per_instance
    }
  }
}

# ---------------------------------------------------------------------------
# Regional URL Map
# Routes all unmatched requests to the backend service.
# Extend path_matcher rules here for host/path-based routing.
# ---------------------------------------------------------------------------

resource "google_compute_region_url_map" "main" {
  name            = "${var.name}-url-map"
  project         = var.project_id
  region          = var.region
  default_service = google_compute_region_backend_service.main.id
}

# ---------------------------------------------------------------------------
# Regional Target HTTPS Proxy
# ---------------------------------------------------------------------------

resource "google_compute_region_target_https_proxy" "main" {
  name             = "${var.name}-https-proxy"
  project          = var.project_id
  region           = var.region
  url_map          = google_compute_region_url_map.main.id
  ssl_certificates = [google_compute_region_ssl_certificate.main.id]
}

# ---------------------------------------------------------------------------
# Forwarding Rule (Internal Managed)
# ---------------------------------------------------------------------------

resource "google_compute_forwarding_rule" "main" {
  name                  = "${var.name}-forwarding-rule"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "INTERNAL_MANAGED"
  target                = google_compute_region_target_https_proxy.main.id
  network               = var.network
  subnetwork            = var.subnetwork
  ip_address            = local.ip_address
  port_range            = "443"
  labels                = local.labels

  allow_global_access = false
}
