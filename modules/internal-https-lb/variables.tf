variable "project_id" {
  description = "The GCP project ID to deploy resources into"
  type        = string
}

variable "region" {
  description = "The GCP region for all regional resources"
  type        = string
}

variable "name" {
  description = "Base name used to prefix all HTTPS ILB resources"
  type        = string
}

variable "network" {
  description = "The self-link or name of the VPC network"
  type        = string
}

variable "subnetwork" {
  description = "The self-link or name of the subnetwork to assign the forwarding rule IP from"
  type        = string
}

variable "proxy_subnet_cidr" {
  description = "CIDR range of the proxy-only subnet (purpose = REGIONAL_MANAGED_PROXY). Used to allow Envoy proxies to reach backends via firewall rule"
  type        = string
}

variable "ip_address" {
  description = "Static internal IP address for the forwarding rule. If empty, one is assigned automatically"
  type        = string
  default     = ""
}

variable "ssl_certificate" {
  description = "PEM-encoded SSL certificate for the HTTPS proxy. Google-managed certificates are not supported for internal HTTPS load balancers"
  type        = string
  sensitive   = true
}

variable "ssl_private_key" {
  description = "PEM-encoded private key for the SSL certificate"
  type        = string
  sensitive   = true
}

variable "health_check_port" {
  description = "Port the health check probe connects to on backend instances"
  type        = number
  default     = 80
}

variable "health_check_request_path" {
  description = "HTTP path the health check requests"
  type        = string
  default     = "/"
}

variable "health_check_source_ranges" {
  description = "Source IP CIDR ranges for the health-check firewall rule"
  type        = list(string)
  default     = ["130.211.0.0/22", "35.191.0.0/16"]
}

variable "backends" {
  description = "Map of backend instance groups and their balancing configuration"
  type = map(object({
    group                 = string
    description           = optional(string, "")
    balancing_mode        = optional(string, "RATE")
    capacity_scaler       = optional(number, 1.0)
    max_rate_per_instance = optional(number, 100)
  }))
  default = {}
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
