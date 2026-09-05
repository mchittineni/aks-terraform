locals {
  merged_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      Component   = "networking"
    },
    var.tags
  )

  subnet_map = {
    for idx, prefix in var.subnet_prefixes :
    format("subnet-%02d", idx + 1) => prefix
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location

  tags = local.merged_tags
}

resource "azurerm_virtual_network" "this" {
  name                = "${var.project_name}-${var.environment}-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  dns_servers         = []

  tags = local.merged_tags
}

resource "azurerm_network_security_group" "default" {
  name                = "${var.project_name}-${var.environment}-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    name                       = "AllowInternal"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = var.vnet_address_space[0]
    destination_address_prefix = var.vnet_address_space[0]
  }

  security_rule {
    name                       = "AllowOutboundInternet"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  tags = local.merged_tags
}

resource "azurerm_subnet" "this" {
  for_each             = local.subnet_map
  name                 = "${var.project_name}-${var.environment}-${each.key}"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [each.value]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.Sql"]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.default.id
}
