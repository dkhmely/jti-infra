data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "db_password" {
  name         = azurerm_key_vault_secret.secret.name
  key_vault_id = azurerm_key_vault.key_vault.id
}

data "azurerm_resource_group" "rg" {
  name = "${var.application}-${var.env}-rg"
}

data "azurerm_key_vault" "kv" {
  name = "${var.application}-${var.env}-kv"
}
