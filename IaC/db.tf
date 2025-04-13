module "mysql" {
  source = "git::https://github.com/dkhmely/jti-terraform-modules.git//modules/mysql?ref=v1.0.12"

  name                       = var.application
  env                        = var.env
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  db_user_prefix             = var.db_user_prefix
  db_name                    = var.application
  key_vault_id               = data.azurerm_key_vault.kv.id
  vnet_id                    = data.azurerm_virtual_network.vnet.id
  private_endpoint_subnet_id = azurerm_subnet.pep_subnet.id

}