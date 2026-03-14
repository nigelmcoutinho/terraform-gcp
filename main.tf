module "internal_tcp_lb" {
  source = "./modules/internal-tcp-lb"

  project_id = var.project_id
  region     = var.region
  name       = var.tcp_lb_name
  network    = var.network
  subnetwork = var.subnetwork

  ports      = var.tcp_lb_ports
  ip_address = var.tcp_lb_ip_address

  health_check_port         = var.tcp_lb_health_check_port
  health_check_request_path = var.tcp_lb_health_check_request_path
  health_check_source_ranges = var.health_check_source_ranges

  session_affinity = var.tcp_lb_session_affinity
  backends         = var.tcp_lb_backends
  labels           = var.labels
}

module "internal_https_lb" {
  source = "./modules/internal-https-lb"

  project_id        = var.project_id
  region            = var.region
  name              = var.https_lb_name
  network           = var.network
  subnetwork        = var.subnetwork
  proxy_subnet_cidr = var.proxy_subnet_cidr

  ip_address      = var.https_lb_ip_address
  ssl_certificate = var.ssl_certificate
  ssl_private_key = var.ssl_private_key

  health_check_port          = var.https_lb_health_check_port
  health_check_request_path  = var.https_lb_health_check_request_path
  health_check_source_ranges = var.health_check_source_ranges

  backends = var.https_lb_backends
  labels   = var.labels
}
