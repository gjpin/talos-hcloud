# Cluster name and base domain
variable "cluster_name" {
  type    = string
  default = "talos"
}

variable "base_domain" {
  type = string
}

# Hetzner SSH keys
variable "hetzner_ssh_keys" {
  type    = list(string)
  default = ["default"]
}

# Number of control plane and worker nodes
variable "num_control_plane_nodes" {
  type    = number
  default = 3
}

variable "num_worker_nodes" {
  type    = number
  default = 2
}

# Nodes image
variable "talos_image_id" {
  type = string
}

# Nodes types
variable "control_plane_node_type" {
  type    = string
  default = "cpx21"
}

variable "worker_node_type" {
  type    = string
  default = "cpx21"
}

# Nodes locations
variable "control_plane_node_location" {
  type    = list(string)
  default = ["nbg1", "hel1", "fsn1"]
}

variable "worker_node_location" {
  type    = string
  default = "nbg1"
}

# Load balancer types
variable "control_plane_load_balancer_type" {
  type    = string
  default = "lb11"
}

variable "control_plane_load_balancer_location" {
  type    = string
  default = "eu-central"
}

# DNS
variable "cloudflare_dns_zone_id" {
  type = string
}