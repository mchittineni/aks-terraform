locals {
  merged_tags = merge(
    {
      Environment = var.environment
      Component   = "azure-sql"
    },
    var.tags
  )
}

resource "random_password" "sql_admin" {
  length      = 20
  special     = true
  min_numeric = 4
  min_upper   = 2
  min_lower   = 4
  min_special = 2
}

resource "azurerm_mssql_server" "this" {
  # checkov:skip=CKV_AZURE_113: Ensure Azure SQL DB does not allow ingress 0.0.0.0/0
  name                = var.server_name
  resource_group_name = var.resource_group_name
  location            = var.location

  version                              = "12.0"
  administrator_login                  = var.admin_username
  administrator_login_password         = random_password.sql_admin.result
  minimum_tls_version                  = "1.2"
  public_network_access_enabled        = true
  outbound_network_restriction_enabled = false

  tags = local.merged_tags
}

resource "azurerm_mssql_database" "this" {
  name                        = var.database_name
  server_id                   = azurerm_mssql_server.this.id
  sku_name                    = var.sku_name
  max_size_gb                 = 32
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  auto_pause_delay_in_minutes = -1

  short_term_retention_policy {
    retention_days = var.backup_retention_days
  }

  long_term_retention_policy {
    weekly_retention  = "P4W"
    monthly_retention = "P12M"
    yearly_retention  = "P5Y"
    week_of_year      = 1
  }

  tags = local.merged_tags
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.this.name
  state               = "Enabled"
  retention_days      = 7
}

resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_virtual_network_rule" "subnet" {
  name      = "${var.database_name}-vnet-rule"
  server_id = azurerm_mssql_server.this.id
  subnet_id = var.subnet_id
}
