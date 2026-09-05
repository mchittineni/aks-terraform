# ==================== AKS Outputs ====================
output "resource_group_name" {
  description = "Name of the Azure Resource Group containing all resources"
  value       = module.azure_networking.resource_group_name
}

output "vnet_id" {
  description = "Resource ID of the Virtual Network"
  value       = module.azure_networking.vnet_id
}

output "subnet_ids" {
  description = "Resource IDs of all created subnets"
  value       = module.azure_networking.subnet_ids
}

output "cluster_name" {
  description = "Name of the provisioned AKS cluster"
  value       = module.azure_compute.cluster_name
}

output "cluster_id" {
  description = "Resource ID of the AKS cluster"
  value       = module.azure_compute.cluster_id
}

output "kubeconfig_command" {
  description = "Azure CLI command to obtain cluster credentials and configure kubectl"
  value       = "az aks get-credentials --resource-group ${module.azure_networking.resource_group_name} --name ${module.azure_compute.cluster_name}"
}

output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name of the Azure SQL server"
  value       = module.azure_database.sql_server_fqdn
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace"
  value       = module.azure_monitoring.workspace_id
}
