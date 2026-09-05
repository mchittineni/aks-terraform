output "workspace_id" {
  description = "Log Analytics workspace ID"
  value       = try(azurerm_log_analytics_workspace.this[0].id, null)
}

output "workspace_primary_shared_key" {
  description = "Primary shared key for the workspace"
  value       = try(azurerm_log_analytics_workspace.this[0].primary_shared_key, null)
  sensitive   = true
}

output "action_group_id" {
  description = "Monitoring action group ID"
  value       = azurerm_monitor_action_group.alerts.id
}

output "activity_log_alert_id" {
  description = "Activity log alert resource ID"
  value       = azurerm_monitor_activity_log_alert.aks_errors.id
}
