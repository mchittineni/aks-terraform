# ==================== Terraform Configuration ====================
# Defines the required Terraform version, providers, and remote Azure Blob backend.
terraform {
  required_version = ">= 1.15.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.20.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.3.0"
    }
  }

  # Configuration for the Azure Blob Storage backend to store state securely.
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatemulticloud"
    container_name       = "tfstate"
    key                  = "aks/terraform.tfstate"
    use_azuread_auth     = true
  }
}

# ==================== Provider Configurations ====================
# Configuration for the Azure Resource Manager Provider.
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.azure_subscription_id
}

# ==================== Locals ====================
locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Application = "Azure-AKS-Terraform"
    Owner       = var.owner_email
    CostCenter  = var.cost_center
  }
}

# ==================== Azure Infrastructure Modules ====================
# Module for configuring Resource Group, Virtual Network, and Subnets.
module "azure_networking" {
  source              = "./modules/azure/networking"
  project_name        = var.project_name
  environment         = var.environment
  location            = var.azure_location
  resource_group_name = "${var.project_name}-${var.environment}-rg"
  vnet_address_space  = var.azure_vnet_address_space
  subnet_prefixes     = var.azure_subnet_prefixes
  tags                = local.common_tags
}

# Module for provisioning the Azure Kubernetes Service (AKS) cluster.
module "azure_compute" {
  source                 = "./modules/azure/compute"
  cluster_name           = "${var.project_name}-${var.environment}-aks"
  location               = var.azure_location
  resource_group_name    = module.azure_networking.resource_group_name
  vnet_id                = module.azure_networking.vnet_id
  subnet_id              = module.azure_networking.subnet_ids[0]
  vm_size                = var.azure_vm_size
  node_count             = var.azure_node_count
  kubernetes_version     = var.kubernetes_version
  enable_private_cluster = var.enable_private_cluster
  environment            = var.environment
  tags                   = local.common_tags
}

# Module for provisioning Azure Database (SQL Server / DB).
module "azure_database" {
  source              = "./modules/azure/database"
  server_name         = "${var.project_name}-${var.environment}-sql"
  database_name       = var.azure_db_name
  location            = var.azure_location
  resource_group_name = module.azure_networking.resource_group_name
  subnet_id           = module.azure_networking.subnet_ids[1]
  admin_username      = var.azure_db_admin_username
  sku_name            = var.azure_db_sku_name
  environment         = var.environment
  tags                = local.common_tags
}

# Module for provisioning Azure Monitor, Log Analytics, and Container Insights.
module "azure_monitoring" {
  source               = "./modules/azure/monitoring"
  location             = var.azure_location
  resource_group_name  = module.azure_networking.resource_group_name
  cluster_id           = module.azure_compute.cluster_id
  environment          = var.environment
  enable_log_analytics = var.enable_monitoring
  alert_email          = var.alert_email
  tags                 = local.common_tags
}
