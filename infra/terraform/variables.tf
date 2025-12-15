variable "cluster_name" {
  type    = string
  default = "devops-test"
}

variable "kind_node_image" {
  type    = string
  default = "kindest/node:v1.29.2"
}

variable "registry_name" {
  type    = string
  default = "kind-registry"
}

variable "registry_port" {
  type    = number
  default = 5001
}
