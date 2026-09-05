variable "location" {
  description = "Azure region for SQL resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group that hosts the SQL server"
  type        = string
}

variable "subnet_id" {
  description = "Subnet allowed to reach the SQL server"
  type        = string
}

variable "server_name" {
  description = "Azure SQL server name"
  type        = string
}

variable "database_name" {
  description = "Azure SQL database name"
  type        = string
}

variable "admin_username" {
  description = "Administrator username"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "Service tier SKU"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "backup_retention_days" {
  description = "Short-term backup retention in days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo redundant backup"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags"
  type        = map(string)
  default     = {}
}
