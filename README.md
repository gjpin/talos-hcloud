## Architecture

The deployment defaults to a 5 node cluster with 1 load balancer:

- 3x Master servers (CPX21)
- 2x Worker servers (CPX21)
- 1x Load balancer for control plane (LB11)

## Features
|  Type | Installed |
|---|---|
| **Container runtimes** | [ContainerD](https://containerd.io/) (default)<br>[gVisor](https://gvisor.dev/) |
| **CNI provider** | [Calico](https://projectcalico.docs.tigera.io/about/about-calico) |
| **CSI provider** | [hcloud CSI](https://github.com/hetznercloud/csi-driver) |
| **Monitoring** | [Metrics server](https://github.com/kubernetes-sigs/metrics-server)<br>[Grafana](https://grafana.com/) with [Prometheus](https://prometheus.io/) datasource and pre-configured dashboards |
| **Ingress controller** | [NGINX](https://kubernetes.github.io/ingress-nginx/) |
| **Certificates controller** | [cert-manager](https://cert-manager.io/) with Let's Encrypt staging/production cluster issuers |
| **Application event-driven autoscaling** | [KEDA](https://keda.sh/) |
| **Cluster autoscaler** | [cluster-autoscaler](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler) with hcloud provider |
| **Load balancer** | [MetalLB](https://metallb.universe.tf/) |
| **External DNS** | [ExternalDNS](https://github.com/kubernetes-sigs/external-dns) with Cloudflare provider |

## Usage

### Create Cloudflare token:
Token should be granted Zone Read, DNS Edit privileges, and access to All zones - [external-dns - Cloudflare](
https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/cloudflare.md)

### Install required CLIs:
```
export TALOSCTL_VERSION="v1.0.5"
export KUBECTL_VERSION="v1.24.0"
export HELM_VERSION="v3.9.0"
export THEILA_VERSION="v0.2.1"
export CALICOCTL_VERSION="v3.23.1"

curl -sSL https://github.com/siderolabs/talos/releases/download/${TALOSCTL_VERSION}/talosctl-linux-amd64 \
    -o ${HOME}/.local/bin/talosctl && chmod +x ${HOME}/.local/bin/talosctl

curl -sSL https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o ${HOME}/.local/bin/kubectl && chmod +x ${HOME}/.local/bin/kubectl

curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz -o helm.tar.gz && \
    tar -xzf helm.tar.gz -C ${HOME}/.local/bin/ linux-amd64/helm --strip-components=1 && rm helm.tar.gz

curl -sSL https://github.com/siderolabs/theila/releases/download/${THEILA_VERSION}/theila-linux-amd64 \
    -o ${HOME}/.local/bin/theila && chmod +x ${HOME}/.local/bin/theila

curl -sSL https://github.com/projectcalico/calico/releases/download/${CALICOCTL_VERSION}/calicoctl-linux-amd64 \
    -o ${HOME}/.local/bin/calicoctl && chmod +x ${HOME}/.local/bin/calicoctl
```

### Set environment variables:
```
# Hetzner Cloud API token
export HCLOUD_TOKEN=""

# Hetzner API token for CSI
export HCLOUD_CSI_TOKEN=""

# Hetzner API token for cluster-autoscaler
export HCLOUD_NODE_TOKEN=""

# Cluster name. eg. talos
export CLUSTER_NAME=""

# Base domain. eg. example.com
export BASE_DOMAIN=""

# Cloudflare zone ID
export CLOUDFLARE_ZONE_ID=""

# Cloudlfare email. eg. user@example.com
export CLOUDFLARE_EMAIL=""

# Cloudflare global API key
export CLOUDFLARE_API_KEY=""

# Cloudflare API token
export CLOUDFLARE_API_TOKEN=""

# The email to be used for Let's Encrypt
export LETSENCRYPT_EMAIL=""

# The password for the Grafana admin user
export GRAFANA_ADMIN_PASSWORD=""
```

### Bootstrap cluster:
Run `./talos-bootstrap`

## Post bootstrap
### Destroy all resources
- `./talos-bootstrap -d`

### Access Theila dashboard
- Export talosconfig: `export TALOSCONFIG="${HOME}/.talos/${CLUSTER_NAME}.config"`
- Run `theila` and [access dashboard](http://localhost:8080/)

### Run examples:
```
sed "s|BASE_DOMAIN|${BASE_DOMAIN}|" examples/nginx-ingress.yaml | \
    kubectl apply -f - >/dev/null

sed "s|BASE_DOMAIN|${BASE_DOMAIN}|" examples/keda-autoscaling.yaml | \
    kubectl apply -f - >/dev/null
```

## Resources
Original Grafana NGINX ingress [dashboard](https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/grafana/dashboards/nginx.json)