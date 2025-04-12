resource "azurerm_subnet" "sql_subnet" {
  name                 = "sql_subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/29"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action"
      ]
    }
  }
}

resource "azurerm_subnet" "webapp_subnet" {
  name                 = "webapp_subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.8/29"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet" "pep_subnet" {
  name                 = "mysql-pep-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.16/29"]
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "privatelink.mysql.database.azure.com"
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_virtual_link" {
  name                  = "${var.application}-${var.env}-mysql-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = data.azurerm_virtual_network.vnet.id
  resource_group_name   = data.azurerm_resource_group.rg.name
}

resource "azurerm_private_endpoint" "mysql_private_endpoint" {
  name                = "${var.application}-${var.env}-mysql-pep"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pep_subnet.id

  private_service_connection {
    name                           = "${var.application}-${var.env}-mysql-psc"
    private_connection_resource_id = azurerm_mysql_flexible_server.sql_server.id
    is_manual_connection           = false
    subresource_names              = ["mysqlServer"]
  }
}

resource "azurerm_private_dns_a_record" "example" {
  name                = "${var.application}${var.env}sql"
  zone_name           = azurerm_private_dns_zone.private_dns_zone.name
  resource_group_name = data.azurerm_resource_group.rg.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.mysql_private_endpoint.private_service_connection[0].private_ip_address]

}