output "resource_group_name" {
  description = "Name of the resource group containing networking assets"
  value       = azurerm_resource_group.this.name
}

output "vnet_id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "subnet_ids" {
  description = "IDs for the created subnets"
  value       = [for subnet in azurerm_subnet.this : subnet.id]
}

output "subnet_names" {
  description = "Names for the created subnets"
  value       = [for subnet in azurerm_subnet.this : subnet.name]
}

output "nsg_id" {
  description = "Network Security Group identifier"
  value       = azurerm_network_security_group.default.id
}
