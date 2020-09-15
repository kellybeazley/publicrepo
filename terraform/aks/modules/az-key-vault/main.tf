data "azurerm_client_config" "kelly" {}

resource "azurerm_resource_group" "kel-rg" {
  name     = var.rg
  location = "westeurope"
}

resource "azurerm_key_vault" "kel-kv" {
  name                            = var.kv_name
  location                        = azurerm_resource_group.kel-rg.location
  resource_group_name             = azurerm_resource_group.kel-rg.name
  tenant_id                       = data.azurerm_client_config.kelly.tenant_id
  soft_delete_enabled             = true
  purge_protection_enabled        = true
  enabled_for_template_deployment = true
  sku_name                        = var.sku

  access_policy {
    tenant_id = data.azurerm_client_config.kelly.tenant_id
    object_id = data.azurerm_client_config.kelly.object_id

    key_permissions = [
      "get",
      "create",
      "list"
    ]

    secret_permissions = [
      "get",
      "create",
      "list"
    ]

    storage_permissions = [
      "get",
    ]
  }

  tags = {
    env = "test"
  }
}
