resource "azurerm_service_plan" "serviceplan" {
  name                = "${var.application}-${var.env}-serviceplan"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "app" {
  name                = "${var.application}-${var.env}-app"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = azurerm_service_plan.serviceplan.location
  service_plan_id     = azurerm_service_plan.serviceplan.id

  identity {
    type = "SystemAssigned"
  }

  site_config {}
  app_settings = {
    "DB_HOST" = "${azurerm_mysql_flexible_server.sql_server.name}.mysql.database.azure.com"
    "DB_USER" = "${var.db_user_prefix}${var.env}user"
    "DB_PASS" = data.azurerm_key_vault_secret.db_password.value
    "DB_NAME" = "${var.application}"
    "DB_PORT" = 3306
  }
}

resource "azurerm_app_service_virtual_network_swift_connection" "connect" {
  app_service_id = azurerm_linux_web_app.app.id
  subnet_id      = azurerm_subnet.webapp_subnet.id
}