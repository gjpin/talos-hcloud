packer {
  required_plugins {
    hcloud = {
      version = ">= 1.0.3"
      source  = "github.com/hashicorp/hcloud"
    }
  }
}

variable "hcloud_token" {
  type    = string
  default = env("HCLOUD_TOKEN")
}

variable "talos_version" {
  type = string
}

source "hcloud" "talos" {
  image           = "debian-11"
  location        = "nbg1"
  server_type     = "cx11"
  snapshot_name   = "talos-${var.talos_version}"
  ssh_keys        = ["default"]
  ssh_username    = "root"
  rescue          = "linux64"
  token           = var.hcloud_token
  snapshot_labels = { os = "talos", version = "${var.talos_version}" }
}

build {
  sources = ["source.hcloud.talos"]

  provisioner "shell" {
    inline = [
      "set -x",
      "curl -sL https://github.com/siderolabs/talos/releases/download/${var.talos_version}/hcloud-amd64.raw.xz | xz -d | dd of=/dev/sda"
    ]
  }
}