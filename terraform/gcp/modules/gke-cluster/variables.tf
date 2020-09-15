variable "cluster_name" {
  description = "Gke Cluster name"
}

variable "node_pool_name" {
  description = "gke node pool name"
}

variable "location" {
  description = "GCP region"
  default     = "europe-west4"
}


variable "node_count" {
  description = "node count"
  default     = "1"
}


variable "machine_type" {
  description = "machine type for nodes"
}

variable "min_node" {
  description = "minimum node for Autoscaling"
}

variable "max_node" {
  description = "maximum node for Autoscaling"
}

variable "node_location" {
  description = "zone zode location"
  type        = list(string)
}

variable "max_pods" {
  description = "maximum pods per node"
}

variable "disk_size_gb" {
  description = "disk size for nodes"
}

variable "disk_type" {
  description = "disk types for nodes"
}
