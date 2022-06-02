# Kubernetes API
resource "cloudflare_record" "dns_a_kubernetes_api" {
  zone_id = var.cloudflare_dns_zone_id
  name    = "api.${var.cluster_name}.${var.base_domain}"
  value   = hcloud_load_balancer.control_plane.ipv4
  type    = "A"
  ttl     = 120
}