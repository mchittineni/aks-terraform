locals {
  merged_tags = merge(
    {
      Environment = var.environment
      Component   = "azure-monitoring"
    },
    var.tags
  )

  workspace_suffix = substr(md5(var.cluster_id), 0, 6)
}

resource "azurerm_log_analytics_workspace" "this" {
  count                      = var.enable_log_analytics ? 1 : 0
  name                       = "log-${var.environment}-${local.workspace_suffix}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  sku                        = "PerGB2018"
  retention_in_days          = 30
  daily_quota_gb             = 10
  internet_ingestion_enabled = true
  internet_query_enabled     = true

  tags = local.merged_tags
}

resource "azurerm_log_analytics_solution" "container_insights" {
  count                 = var.enable_log_analytics ? 1 : 0
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this[0].id
  workspace_name        = azurerm_log_analytics_workspace.this[0].name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_monitor_action_group" "alerts" {
  name                = "ag-${var.environment}-aks"
  resource_group_name = var.resource_group_name
  short_name          = "aksalerts"

  email_receiver {
    name                    = "primary"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = local.merged_tags
}

resource "azurerm_monitor_activity_log_alert" "aks_errors" {
  name                = "alert-${var.environment}-aks"
  resource_group_name = var.resource_group_name
  scopes              = [var.cluster_id]
  location            = "Global"
  description         = "Alert on AKS administrative errors"
  enabled             = true

  criteria {
    category = "Administrative"
    level    = "Error"
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "aks" {
  count                      = var.enable_log_analytics ? 1 : 0
  name                       = "diag-${var.environment}-aks"
  target_resource_id         = var.cluster_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this[0].id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  metric {
    category = "AllMetrics"
  }
}
