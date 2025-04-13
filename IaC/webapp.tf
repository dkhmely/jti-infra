module "webapp" {
  source              = "git::https://github.com/dkhmely/jti-terraform-modules.git//modules/webapp?ref=v1.0.5"
  name                = "${var.application}-${var.env}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  acr                 = azurerm_container_registry.acr.id
  kv                  = data.azurerm_key_vault.kv.id

  db_host                = "${azurerm_mysql_flexible_server.sql_server.name}.mysql.database.azure.com"
  db_user                = "${var.db_user_prefix}${var.env}user"
  db_password_secret_uri = "https://${data.azurerm_key_vault.kv.name}.vault.azure.net/secrets/${azurerm_key_vault_secret.secret.name}/"
  db_name                = var.application
  subnet_id              = azurerm_subnet.webapp_subnet.id
  vnet_integration       = true

  site_config = {
    container_registry_use_managed_identity = true
    always_on                               = true
    use_32_bit_worker                       = false
  }
}