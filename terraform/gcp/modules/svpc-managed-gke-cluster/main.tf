resource "random_id" "project" {
  byte_length = 4
  prefix      = var.gcp_project_id
}

resource "google_project" "project" {
  name            = var.project_name
  project_id      = random_id.project.hex
  billing_account = "********"
  folder_id       = "**********"
  labels = tomap({ "env" = var.env,
    "costcentre" = var.costcentre,
    "team"       = var.team,
    "owner"      = var.owner,
  })
}


resource "google_project_service" "activate_apis" {
  project                    = random_id.project.hex
  disable_dependent_services = true
  count                      = length(var.activate_apis)
  service                    = element(var.activate_apis, count.index)

  depends_on = [
    google_project.project,
  ]
}


resource "google_project_iam_binding" "project_members" {
  project = random_id.project.hex
  role    = "roles/container.developer"
  members = concat(formatlist("user:%s", var.user_email), ["serviceAccount:${google_service_account.service_account.email}"])

  depends_on = [
    google_project_service.activate_apis,
  ]
}

resource "google_project_iam_member" "project_members" {
  project = "*************"
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:service-${google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"

  depends_on = [
    google_project_service.activate_apis,
  ]
}

resource "google_service_account" "service_account" {
  account_id   = "${google_project.project.name}-mgke"
  display_name = "ged-gke-service-account"
  description  = "for user to deploy to cluster, created by terraform"
  project      = random_id.project.hex
}

resource "google_service_account_iam_binding" "key_admin" {
  service_account_id = google_service_account.service_account.id
  role               = "roles/iam.serviceAccountKeyAdmin"

  members = formatlist("user:%s", var.user_email)

}

#-----Subnet Creation-----------------------------------------------------

resource "google_compute_subnetwork" "ged-gke" {
  name          = "${google_project.project.name}-mgke"
  ip_cidr_range = var.subnet
  project       = "**********"
  network       = "vpc-network"
  region        = "europe-west4"

  secondary_ip_range {
    range_name    = "${google_project.project.name}-pods"
    ip_cidr_range = var.pods
  }

  secondary_ip_range {
    range_name    = "${google_project.project.name}-services"
    ip_cidr_range = var.services
  }
}
#-----IAM Policy for service account------------

data "google_iam_policy" "gke-service-account-IAM-policy" {
  binding {
    role = "roles/compute.networkUser"

    members = [
      "serviceAccount:${google_project.project.number}@cloudservices.gserviceaccount.com",
      "serviceAccount:service-${google_project.project.number}@container-engine-robot.iam.gserviceaccount.com",
    ]
  }
}

resource "google_compute_subnetwork_iam_policy" "gke-service-account-iam-policy" {
  provider    = google-beta
  subnetwork  = "${google_project.project.name}-mgke"
  project     = "************"
  policy_data = data.google_iam_policy.gke-service-account-IAM-policy.policy_data
  depends_on = [
  google_project_service.activate_apis, ]
}

#-----attach service project to host project-------------------------

resource "google_compute_shared_vpc_service_project" "ged-gke" {
  host_project    = "***********"
  service_project = random_id.project.hex
  depends_on = [
    google_project_service.activate_apis,
  ]
}


#-----GKE Cluster Creation-----------------------------------------------------


data "google_client_config" "default" {
}

provider "kubernetes" {
  load_config_file = false

  host  = "https://${google_container_cluster.ged-gke.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.ged-gke.master_auth[0].cluster_ca_certificate,
  )
}

data "google_container_engine_versions" "gke_version" {
  location = var.location
}

resource "google_container_cluster" "ged-gke" {
  name       = var.cluster_name
  project    = random_id.project.hex
  location   = var.location
  network    = "https://www.googleapis.com/compute/v1/projects/*************/global/networks/vpc-network"
  subnetwork = google_compute_subnetwork.ged-gke.self_link

  default_max_pods_per_node = var.max_pods

  remove_default_node_pool = true
  initial_node_count       = var.node_count
  min_master_version       = "latest"

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_locations = var.node_location

  ip_allocation_policy {
    cluster_secondary_range_name  = "${google_project.project.name}-pods"
    services_secondary_range_name = "${google_project.project.name}-services"
  }

  network_policy {
    enabled = true
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }

  resource_labels = {
    env = var.env
  }


  depends_on = [
    google_project_service.activate_apis,
    google_compute_shared_vpc_service_project.ged-gke,
    google_project_iam_member.project_members,

  ]
}


resource "google_container_node_pool" "ged-gke-node-pool" {
  name       = var.node_pool_name
  location   = var.location
  project    = random_id.project.hex
  cluster    = google_container_cluster.ged-gke.name
  node_count = 1
  version    = "latest"

  autoscaling {
    min_node_count = var.min_node
    max_node_count = var.max_node
  }

  gement {
    auto_repair = true
  }

  node_config {
    machine_type = var.machine_type
    service_account = google_service_account.service_account.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}

resource "kubernetes_config_map" "ip-masq-agent" {
  metadata {
    name      = "ip-masq-agent"
    namespace = "kube-system"
  }

  data = {
    config = yamlencode({
      nonMasqueradeCIDRs = var.nonipmasq
      masqLinkLocal      = false
      resyncInterval     = "60s"
    })
  }
}

output "project_id" {
  value = "google_project.project.project_id"
}
