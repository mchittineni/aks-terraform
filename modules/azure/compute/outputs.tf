output "cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_id" {
  description = "AKS resource ID"
  value       = azurerm_kubernetes_cluster.this.id
}

output "kube_config" {
  description = "Raw kubeconfig for interacting with AKS"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "node_resource_group" {
  description = "Resource group that hosts AKS managed resources"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}
