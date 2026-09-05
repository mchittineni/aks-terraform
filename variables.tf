# ==================== Core Project Variables ====================
variable "project_name" {
  description = "Name of the project used for naming and tagging resources"
  type        = string
  default     = "cloud-platform"
}

variable "environment" {
  description = "Target deployment environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "owner_email" {
  description = "Email of the project owner for resource tagging and tracking"
  type        = string
  default     = "platform-team@example.com"
}

variable "cost_center" {
  description = "Cost center or business unit identifier for billing"
  type        = string
  default     = "infrastructure"
}

# ==================== Azure Provider Variables ====================
variable "azure_subscription_id" {
  description = "Azure Subscription ID to deploy resources into"
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
}

variable "azure_location" {
  description = "Azure region where resources will be provisioned"
  type        = string
  default     = "eastus"
}

# ==================== Azure Networking Variables ====================
variable "azure_vnet_address_space" {
  description = "Address space for the Azure Virtual Network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "azure_subnet_prefixes" {
  description = "Subnet prefixes for AKS nodes, databases, and general workloads"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# ==================== AKS Compute Variables ====================
variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.32"
}

variable "azure_vm_size" {
  description = "Virtual Machine size for the AKS default system node pool"
  type        = string
  default     = "Standard_D2s_v5"
}

variable "azure_node_count" {
  description = "Initial node count for the AKS default node pool"
  type        = number
  default     = 2
}

variable "enable_private_cluster" {
  description = "Whether to create the AKS cluster with a private API server"
  type        = bool
  default     = false
}

# ==================== Azure Database Variables ====================
variable "azure_db_name" {
  description = "Name of the Azure SQL Database"
  type        = string
  default     = "appdb"
}

variable "azure_db_admin_username" {
  description = "Administrator login for Azure SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "azure_db_sku_name" {
  description = "SKU for the Azure SQL database (e.g. S0, GP_Gen5_2)"
  type        = string
  default     = "S0"
}

# ==================== Monitoring & Alerts Variables ====================
variable "enable_monitoring" {
  description = "Enable Azure Log Analytics and Container Insights"
  type        = bool
  default     = true
}

variable "alert_email" {
  description = "Email address for Azure Monitor action group alerts"
  type        = string
  default     = "alerts@example.com"
}
