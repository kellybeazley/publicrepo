resource "kubernetes_namespace" "jenkins_namespace" {
  metadata {
    name = var.namespace
  }
}

resource "google_compute_global_address" "jenkins-external-ip" {
  name = var.external_ip
}

resource "google_dns_record_set" "jenkins-helm" {
  name = var.domain_name
  type = "A"
  ttl  = 300

  managed_zone = "demo-cloud"
  rrdatas      = [google_compute_global_address.jenkins-external-ip.address]
}


resource "google_compute_managed_ssl_certificate" "jenkins-cert" {
  provider = google-beta
  name = var.cert_name

  managed {
    domains = [var.domain_name]
  }
}


resource "helm_release" "jenkins-helm" {
  name      = "jenkins-helm-test"
  chart     = "stable/jenkins"
  namespace = var.namespace

  values = [
    "${file("values.yaml")}"
  ]
}
