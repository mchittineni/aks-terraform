output "sql_server_fqdn" {
  description = "Fully qualified domain name for the SQL server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
  sensitive   = true
}

output "database_id" {
  description = "Resource ID of the SQL database"
  value       = azurerm_mssql_database.this.id
}

output "admin_username" {
  description = "Administrator username"
  value       = azurerm_mssql_server.this.administrator_login
  sensitive   = true
}

output "admin_password" {
  description = "Generated administrator password"
  value       = random_password.sql_admin.result
  sensitive   = true
}
