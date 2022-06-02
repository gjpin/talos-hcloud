output "control_plane_node_0_ip" {
  value = hcloud_server.control_plane_nodes[0].ipv4_address
}

output "worker_node_0_ip" {
  value = hcloud_server.worker_nodes[0].ipv4_address
}

output "worker_node_1_ip" {
  value = hcloud_server.worker_nodes[1].ipv4_address
}