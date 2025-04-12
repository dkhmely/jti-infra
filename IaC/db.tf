resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_mysql_flexible_server" "sql_server" {
  name                   = "${var.application}${var.env}sql"
  resource_group_name    = data.azurerm_resource_group.rg.name
  location               = data.azurerm_resource_group.rg.location
  administrator_login    = "${var.db_user_prefix}${var.env}user"
  administrator_password = random_password.password.result
  backup_retention_days  = 7
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  sku_name               = "B_Standard_B1ms"
  zone                   = 3

  storage {
    auto_grow_enabled = true
    iops              = 360
    size_gb           = 20
  }

  lifecycle {
    ignore_changes = [private_dns_zone_id]
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns_virtual_link]
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = var.application
  resource_group_name = data.azurerm_resource_group.rg.name
  server_name         = azurerm_mysql_flexible_server.sql_server.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}