module "managed-gke" {
  source                = "../modules/svpc-managed-gke-cluster"
  # PROJECT NAME AND USERS
  project_name          = "test-gke"
  user_email            = ["kelly@email.com"]
  # PROJECT TAGS -----------------------------------------------------------------------------------------------
  # Only hyphens (-), underscores (_), lowercase characters and numbers are allowed. International characters are allowed.
  env                   = "test"
  costcentre            = "********"
  owner                 = "kel"
  team                  = "kel-team"
  #-----------------------------------------
  #SUBNETS
  subnet                = "*.*.*.*/27"
  pods                  = "*.*.*.*/20"
  services              = "*.*.*.*/20"
  #----------GKE Cluster---------
  cluster_name          = "test-gke"
  node_pool_name        = "test-gke-pool"
  nonipmasq             = ["*.0.0.0/16"]
  machine_type          = "n1-standard-4"
  min_node              = "1"
  max_node              = "8"
  node_count            = "2"
  max_pods              = "110"
  node_location         = ["europe-west4-a", "europe-west4-b"]
  disk_type             = "pd-standard"
  disk_size_gb          = "100"
}
