# Kubernetes API
resource "cloudflare_record" "dns_a_kubernetes_api" {
  count = var.num_control_plane_nodes

  zone_id = var.cloudflare_dns_zone_id
  name    = "api.${var.cluster_name}.${var.base_domain}"
  value   = hcloud_server.control_plane_nodes[count.index].ipv4_address
  type    = "A"
  ttl     = 60
}