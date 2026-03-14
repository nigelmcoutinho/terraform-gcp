output "forwarding_rule_id" {
  description = "The ID of the internal TCP forwarding rule"
  value       = google_compute_forwarding_rule.main.id
}

output "forwarding_rule_ip_address" {
  description = "The internal IP address assigned to the forwarding rule"
  value       = google_compute_forwarding_rule.main.ip_address
}

output "backend_service_id" {
  description = "The ID of the regional TCP backend service"
  value       = google_compute_region_backend_service.main.id
}

output "health_check_id" {
  description = "The ID of the health check"
  value       = google_compute_health_check.main.id
}

output "health_check_firewall_id" {
  description = "The ID of the firewall rule that allows health check probes"
  value       = google_compute_firewall.health_check.id
}
