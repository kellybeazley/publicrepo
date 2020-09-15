variable "gcp_project_id" {
  description = "random project id created"
  default     = "project-"
}

# variable "billing_account" {}
variable "region" {
  description = "GCP Region"
  default     = "europe-west4"
}


variable "project_name" {
  description = "project name to be created"
}


variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default     = ["compute.googleapis.com", "container.googleapis.com"]
}


variable "user_email" {
  description = "user to add to gcp project"
  type        = list(string)


}


#PROJECT TAGS --------------------------------------------------------------------------------------------

variable "env" {
  description = "Map of labels for project"
  type        = string
}


variable "costcentre" {
  description = "Map of labels for project"
  type        = string
}



variable "owner" {
  description = "Map of labels for project"
  type        = string
}


variable "team" {
  description = "Map of labels for project"
  type        = string
}


#----------subnet vars-------------------------------------------------------------

variable "subnet" {
  description = "subnet cidr"
  type        = string
}

variable "pods" {
  description = "pods cidr"
  # type        = string
}

variable "services" {
  description = "services cidr"
  # type        = string
}

#---------------GKE Cluster vars-------------------------------------------------------------
variable "cluster_name" {
  description = "gke cluster name"
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


variable "nonipmasq" {
  description = "nonMasqueradeCIDRs"
  type        = list(string)
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
