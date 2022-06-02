# Control Plane nodes
data "local_file" "control_plane_machine_config" {
  filename = "${path.module}/generated-files/controlplane.yaml"
}

resource "hcloud_server" "control_plane_nodes" {
  count = var.num_control_plane_nodes

  name        = "${var.cluster_name}-control-plane-${count.index}"
  server_type = var.control_plane_node_type
  image       = var.talos_image_id
  location    = var.control_plane_node_location[count.index]
  user_data   = data.local_file.control_plane_machine_config.content
  ssh_keys    = var.hetzner_ssh_keys
  labels = {
    "cluster" = var.cluster_name,
    "type"    = "control_plane"
  }
}

# Worker nodes
data "local_file" "worker_machine_config" {
  filename = "${path.module}/generated-files/worker.yaml"
}

resource "hcloud_server" "worker_nodes" {
  count = var.num_worker_nodes

  name        = "${var.cluster_name}-worker-${count.index}"
  server_type = var.worker_node_type
  image       = var.talos_image_id
  location    = var.worker_node_location
  user_data   = data.local_file.worker_machine_config.content
  ssh_keys    = var.hetzner_ssh_keys
  labels = {
    "cluster" = var.cluster_name,
    "type"    = "worker"
  }
}