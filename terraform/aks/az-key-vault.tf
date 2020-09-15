module "aks-cluster1" {
  source          = ".//modules/az-key-vault"
  rg              = "kelly-rg"
  kv_name         = "kel-key-vault"
  sku             = "standard"
}
