data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "db_password" {
  name         = azurerm_key_vault_secret.secret.name
  key_vault_id = data.azurerm_key_vault.kv.id
}

data "azurerm_resource_group" "rg" {
  name = "${var.application}-${var.env}-rg"
}

data "azurerm_key_vault" "kv" {
  name                = "${var.application}-${var.env}-kv"
  resource_group_name = data.azurerm_resource_group.rg.name
}

data "azurerm_virtual_network" "vnet" {
  name                = "${var.application}-${var.env}-vnet"
  resource_group_name = data.azurerm_resource_group.rg.name
}
