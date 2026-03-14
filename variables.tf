# ---------------------------------------------------------------------------
# Shared
# ---------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID to deploy resources into"
  type        = string
}

variable "region" {
  description = "The GCP region for all regional resources"
  type        = string
  default     = "us-central1"
}

variable "network" {
  description = "The self-link or name of the VPC network shared by both load balancers"
  type        = string
}

variable "subnetwork" {
  description = "The self-link or name of the subnetwork to assign forwarding rule IPs from"
  type        = string
}

variable "health_check_source_ranges" {
  description = "GCP health check prober CIDR ranges shared by both load balancers"
  type        = list(string)
  default     = ["130.211.0.0/22", "35.191.0.0/16"]
}

variable "labels" {
  description = "Labels applied to all resources in both load balancers"
  type        = map(string)
  default     = {}
}

# ---------------------------------------------------------------------------
# Internal TCP Load Balancer
# ---------------------------------------------------------------------------

variable "tcp_lb_name" {
  description = "Base name prefix for all TCP ILB resources"
  type        = string
  default     = "internal-tcp-lb"
}

variable "tcp_lb_ip_address" {
  description = "Static internal IP for the TCP forwarding rule. Leave empty for automatic assignment"
  type        = string
  default     = ""
}

variable "tcp_lb_ports" {
  description = "Ports the TCP ILB forwards traffic on"
  type        = list(string)
  default     = ["80"]
}

variable "tcp_lb_health_check_port" {
  description = "Port the TCP ILB health check probe connects to"
  type        = number
  default     = 80
}

variable "tcp_lb_health_check_request_path" {
  description = "HTTP path the TCP ILB health check requests"
  type        = string
  default     = "/"
}

variable "tcp_lb_session_affinity" {
  description = "Session affinity type for the TCP backend service"
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "CLIENT_IP", "CLIENT_IP_PORT_PROTO", "CLIENT_IP_PROTO"], var.tcp_lb_session_affinity)
    error_message = "session_affinity must be one of: NONE, CLIENT_IP, CLIENT_IP_PORT_PROTO, CLIENT_IP_PROTO."
  }
}

variable "tcp_lb_backends" {
  description = "Map of backend instance groups for the TCP ILB"
  type = map(object({
    group          = string
    description    = optional(string, "")
    failover       = optional(bool, false)
    balancing_mode = optional(string, "CONNECTION")
  }))
  default = {}
}

# ---------------------------------------------------------------------------
# Internal HTTPS Load Balancer
# ---------------------------------------------------------------------------

variable "https_lb_name" {
  description = "Base name prefix for all HTTPS ILB resources"
  type        = string
  default     = "internal-https-lb"
}

variable "https_lb_ip_address" {
  description = "Static internal IP for the HTTPS forwarding rule. Leave empty for automatic assignment"
  type        = string
  default     = ""
}

variable "proxy_subnet_cidr" {
  description = "CIDR range of the proxy-only subnet (purpose = REGIONAL_MANAGED_PROXY). Required for INTERNAL_MANAGED load balancers"
  type        = string
}

variable "ssl_certificate" {
  description = "PEM-encoded SSL certificate for the internal HTTPS load balancer. Google-managed certificates are not supported for internal HTTPS LBs"
  type        = string
  sensitive   = true
}

variable "ssl_private_key" {
  description = "PEM-encoded private key matching the SSL certificate"
  type        = string
  sensitive   = true
}

variable "https_lb_health_check_port" {
  description = "Port the HTTPS ILB health check probe connects to"
  type        = number
  default     = 80
}

variable "https_lb_health_check_request_path" {
  description = "HTTP path the HTTPS ILB health check requests"
  type        = string
  default     = "/"
}

variable "https_lb_backends" {
  description = "Map of backend instance groups for the HTTPS ILB"
  type = map(object({
    group                 = string
    description           = optional(string, "")
    balancing_mode        = optional(string, "RATE")
    capacity_scaler       = optional(number, 1.0)
    max_rate_per_instance = optional(number, 100)
  }))
  default = {}
}
