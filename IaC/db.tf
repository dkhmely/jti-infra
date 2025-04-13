module "mysql" {
  source = "git::https://github.com/dkhmely/jti-terraform-modules.git//modules/mysql?ref=v1.0.7"

  name                       = var.application
  env                        = var.env
  location                   = data.azurerm_resource_group.rg.location
  resource_group_name        = data.azurerm_resource_group.rg.name
  db_user_prefix             = var.db_user_prefix
  db_name                    = var.application
  key_vault_id               = data.azurerm_key_vault.kv.id
  secret_name                = "app-sql-user-password"
  private_dns_zone_id        = azurerm_private_dns_zone.private_dns_zone.id
  private_endpoint_subnet_id = azurerm_subnet.pep_subnet.id
  dns_zone_name              = azurerm_private_dns_zone.private_dns_zone.name

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_virtual_link]
}