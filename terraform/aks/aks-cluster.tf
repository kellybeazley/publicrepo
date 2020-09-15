module "aks-cluster1" {
  source                = ".//modules/aks-cluster"
  name                  = "kelly-test"
  rg                    = "kelly"
  location              = "westeurope"
  node_pool_name        = "kbpool"
  vm_size               = "Standard_D2_v2"
}
