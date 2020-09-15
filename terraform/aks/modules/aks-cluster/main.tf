resource "azurerm_kubernetes_cluster" "my_cluster" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg
  dns_prefix          = "kel"

  default_node_pool {
    name       = var.node_pool_name
    node_count = 1
    vm_size    = var.vm_size
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    environment = "test"
  }
}
