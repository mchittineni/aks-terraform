variable "location" {
  description = "Azure region for monitoring resources"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group hosting the monitoring stack"
  type        = string
}

variable "cluster_id" {
  description = "Resource ID of the AKS cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "enable_log_analytics" {
  description = "Toggle for Log Analytics workspace creation"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email used for action group notifications"
  type        = string
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}
