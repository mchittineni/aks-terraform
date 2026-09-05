locals {
  merged_tags = merge(
    {
      Environment = var.environment
      Component   = "aks"
    },
    var.tags
  )
}

resource "tls_private_key" "aks" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_kubernetes_cluster" "this" {
  # checkov:skip=CKV_AZURE_172: ADD REASON
  name                    = var.cluster_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  kubernetes_version      = var.kubernetes_version
  dns_prefix              = "${var.cluster_name}-dns"
  sku_tier                = "Standard"
  private_cluster_enabled = var.enable_private_cluster

  default_node_pool {
    name                 = "system"
    node_count           = var.node_count
    vm_size              = var.vm_size
    vnet_subnet_id       = var.subnet_id
    max_pods             = 110
    orchestrator_version = var.kubernetes_version
    os_disk_size_gb      = 128
    type                 = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "aksadmin"

    ssh_key {
      key_data = tls_private_key.aks.public_key_openssh
    }
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    outbound_type     = "loadBalancer"
    dns_service_ip    = "10.2.0.10"
    service_cidr      = "10.2.0.0/24"
  }

  role_based_access_control_enabled = true

  tags = local.merged_tags
}
