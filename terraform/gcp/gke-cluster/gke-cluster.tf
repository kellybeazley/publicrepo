module "managed-gke" {
  source         = "../modules/gke-cluster"
  #----------GKE Cluster---------
  cluster_name   = "test"
  node_pool_name = "test-pool"
  machine_type   = "n1-standard-4"
  min_node       = "1"
  max_node       = "8"
  node_count     = "2"
  node_location  = ["europe-west2-a", "europe-west2-b"]
  disk_type      = "pd-standard"
  disk_size_gb   = "100"
  location       = "europe-west2"
}
