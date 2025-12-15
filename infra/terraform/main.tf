locals {
  registry_host = "localhost:${var.registry_port}"
}

resource "local_file" "kind_config" {
  filename = "${path.module}/kind-config.yaml"
  content  = <<-YAML
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
containerdConfigPatches:
- |-
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."${local.registry_host}"]
    endpoint = ["http://${var.registry_name}:${var.registry_port}"]
nodes:
- role: control-plane
  image: ${var.kind_node_image}
- role: worker
  image: ${var.kind_node_image}
YAML
}

resource "null_resource" "registry" {
  provisioner "local-exec" {
    command = <<EOT
set -e
if [ -z "$(docker ps -q -f name=^/${var.registry_name}$)" ]; then
  docker run -d --restart=always -p ${var.registry_port}:5000 --name ${var.registry_name} registry:2
fi
EOT
    interpreter = ["bash", "-lc"]
  }
}

resource "null_resource" "kind_cluster" {
  depends_on = [null_resource.registry, local_file.kind_config]

  provisioner "local-exec" {
    command = <<EOT
set -e
kind get clusters | grep -q "^${var.cluster_name}$" || kind create cluster --name ${var.cluster_name} --config ${local_file.kind_config.filename}
EOT
    interpreter = ["bash", "-lc"]
  }

  provisioner "local-exec" {
    command = <<EOT
set -e
docker network connect kind ${var.registry_name} >/dev/null 2>&1 || true

kubectl apply -f - <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: local-registry-hosting
  namespace: kube-public
data:
  localRegistryHosting.v1: |
    host: "${local.registry_host}"
    help: "https://kind.sigs.k8s.io/docs/user/local-registry/"
YAML
EOT
    interpreter = ["bash", "-lc"]
  }
}

output "registry" {
  value = local.registry_host
}

output "cluster_name" {
  value = var.cluster_name
}
