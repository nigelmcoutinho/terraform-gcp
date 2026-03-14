output "forwarding_rule_id" {
  description = "The ID of the internal HTTPS forwarding rule"
  value       = google_compute_forwarding_rule.main.id
}

output "forwarding_rule_ip_address" {
  description = "The internal IP address assigned to the forwarding rule"
  value       = google_compute_forwarding_rule.main.ip_address
}

output "backend_service_id" {
  description = "The ID of the regional HTTPS backend service"
  value       = google_compute_region_backend_service.main.id
}

output "url_map_id" {
  description = "The ID of the regional URL map"
  value       = google_compute_region_url_map.main.id
}

output "https_proxy_id" {
  description = "The ID of the regional target HTTPS proxy"
  value       = google_compute_region_target_https_proxy.main.id
}

output "ssl_certificate_id" {
  description = "The ID of the regional SSL certificate"
  value       = google_compute_region_ssl_certificate.main.id
}

output "health_check_id" {
  description = "The ID of the regional health check"
  value       = google_compute_region_health_check.main.id
}
