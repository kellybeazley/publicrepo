variable "namespace" {
  default     = "jenkins-helm"
  description = "k8s namespace"
}


variable "project" {
  default     = "*******"
  description = "project ID"
}


variable "external_ip" {
  default     = "jenkins-external-ip"
  description = "external IP name"
}


variable "cert_name" {
  default     = "jenkins"
  description = "Google Managed SSL cert name"
}

variable "domain_name" {
  default     = "jenkins-helm.demo.cloud."
  description = "domain_name"
}
