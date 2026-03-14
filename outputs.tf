# ---------------------------------------------------------------------------
# Internal TCP Load Balancer
# ---------------------------------------------------------------------------

output "tcp_lb_forwarding_rule_id" {
  description = "The ID of the TCP ILB forwarding rule"
  value       = module.internal_tcp_lb.forwarding_rule_id
}

output "tcp_lb_ip_address" {
  description = "The internal IP address of the TCP ILB"
  value       = module.internal_tcp_lb.forwarding_rule_ip_address
}

output "tcp_lb_backend_service_id" {
  description = "The ID of the TCP ILB backend service"
  value       = module.internal_tcp_lb.backend_service_id
}

output "tcp_lb_health_check_id" {
  description = "The ID of the TCP ILB health check"
  value       = module.internal_tcp_lb.health_check_id
}

# ---------------------------------------------------------------------------
# Internal HTTPS Load Balancer
# ---------------------------------------------------------------------------

output "https_lb_forwarding_rule_id" {
  description = "The ID of the HTTPS ILB forwarding rule"
  value       = module.internal_https_lb.forwarding_rule_id
}

output "https_lb_ip_address" {
  description = "The internal IP address of the HTTPS ILB"
  value       = module.internal_https_lb.forwarding_rule_ip_address
}

output "https_lb_backend_service_id" {
  description = "The ID of the HTTPS ILB backend service"
  value       = module.internal_https_lb.backend_service_id
}

output "https_lb_url_map_id" {
  description = "The ID of the HTTPS ILB URL map"
  value       = module.internal_https_lb.url_map_id
}

output "https_lb_https_proxy_id" {
  description = "The ID of the HTTPS ILB target proxy"
  value       = module.internal_https_lb.https_proxy_id
}

output "https_lb_health_check_id" {
  description = "The ID of the HTTPS ILB regional health check"
  value       = module.internal_https_lb.health_check_id
}
