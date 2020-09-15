

data "google_container_engine_versions" "gke_version" {
  location = var.location
}

resource "google_container_cluster" "gke" {
  name                      = var.cluster_name
  project                   = "kelly-289613"
  location                  = var.location
  remove_default_node_pool  = true
  initial_node_count        = var.node_count
  min_master_version        = "latest"
  
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_locations = var.node_location



  network_policy {
    enabled = true
  }

  addons_config {
    network_policy_config {
      disabled = false
    }
  }


}


resource "google_container_node_pool" "gke-node-pool" {
  name       = var.node_pool_name
  location   = var.location
  project    = "kelly-289613"
  cluster    = google_container_cluster.gke.name
  node_count = 1
  version    = "latest"

  autoscaling {
    min_node_count = var.min_node
    max_node_count = var.max_node
  }

  management {
    auto_repair = true
  }

  node_config {
    machine_type = var.machine_type

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }
}
