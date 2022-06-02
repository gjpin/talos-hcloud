# Control plane load balancer
resource "hcloud_load_balancer" "control_plane" {
  name               = "${var.cluster_name}-control-plane"
  load_balancer_type = var.control_plane_load_balancer_type
  network_zone       = var.control_plane_load_balancer_location
  algorithm {
    type = "round_robin"
  }
  labels = {
    "cluster" = var.cluster_name,
    "type"    = "control_plane"
  }
}

resource "hcloud_load_balancer_target" "control_plane" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  type             = "label_selector"
  label_selector   = "type=control_plane"
}

resource "hcloud_load_balancer_service" "kubernetes_api" {
  load_balancer_id = hcloud_load_balancer.control_plane.id
  protocol         = "tcp"
  listen_port      = 6443
  destination_port = 6443

  health_check {
    protocol = "tcp"
    port     = 6443
    interval = 10
    timeout  = 10
    retries  = 3
  }
}