locals {
  labels     = merge({ managed-by = "terraform" }, var.labels)
  ip_address = var.ip_address != "" ? var.ip_address : null
}

# ---------------------------------------------------------------------------
# Health Check (global)
# ---------------------------------------------------------------------------

resource "google_compute_health_check" "main" {
  name                = "${var.name}-health-check"
  project             = var.project_id
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
# Regional Backend Service
# ---------------------------------------------------------------------------

resource "google_compute_region_backend_service" "main" {
  name                  = "${var.name}-backend-service"
  project               = var.project_id
  region                = var.region
  protocol              = "TCP"
  load_balancing_scheme = "INTERNAL"
  session_affinity      = var.session_affinity
  health_checks         = [google_compute_health_check.main.id]

  dynamic "backend" {
    for_each = var.backends

    content {
      group          = backend.value.group
      description    = backend.value.description
      failover       = backend.value.failover
      balancing_mode = backend.value.balancing_mode
    }
  }
}

# ---------------------------------------------------------------------------
# Forwarding Rule (Internal)
# ---------------------------------------------------------------------------

resource "google_compute_forwarding_rule" "main" {
  name                  = "${var.name}-forwarding-rule"
  project               = var.project_id
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  backend_service       = google_compute_region_backend_service.main.id
  network               = var.network
  subnetwork            = var.subnetwork
  ip_address            = local.ip_address
  ports                 = var.ports
  labels                = local.labels

  allow_global_access = false
}
