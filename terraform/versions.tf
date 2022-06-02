terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.33.2"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.15.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
  }
}