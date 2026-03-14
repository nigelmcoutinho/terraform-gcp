variable "project_id" {
  description = "The GCP project ID to deploy resources into"
  type        = string
}

variable "region" {
  description = "The GCP region for all regional resources"
  type        = string
}

variable "name" {
  description = "Base name used to prefix all TCP ILB resources"
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

variable "ip_address" {
  description = "Static internal IP address for the forwarding rule. If empty, one is assigned automatically"
  type        = string
  default     = ""
}

variable "ports" {
  description = "List of ports the ILB will forward traffic on"
  type        = list(string)
  default     = ["80"]
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

variable "session_affinity" {
  description = "Session affinity type for the backend service"
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "CLIENT_IP", "CLIENT_IP_PORT_PROTO", "CLIENT_IP_PROTO"], var.session_affinity)
    error_message = "session_affinity must be one of: NONE, CLIENT_IP, CLIENT_IP_PORT_PROTO, CLIENT_IP_PROTO."
  }
}

variable "backends" {
  description = "Map of backend instance groups and their balancing configuration"
  type = map(object({
    group          = string
    description    = optional(string, "")
    failover       = optional(bool, false)
    balancing_mode = optional(string, "CONNECTION")
  }))
  default = {}
}

variable "labels" {
  description = "Labels to apply to all resources"
  type        = map(string)
  default     = {}
}
