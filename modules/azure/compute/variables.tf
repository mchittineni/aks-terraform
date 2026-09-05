variable "location" {
  description = "Azure region where AKS will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name that hosts AKS"
  type        = string
}

variable "vnet_id" {
  description = "Virtual Network ID for reference"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID used by the default node pool"
  type        = string
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name"
  type        = string
}

variable "node_count" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version for AKS"
  type        = string
  default     = "1.32"
}

variable "enable_private_cluster" {
  description = "Deploy AKS as a private cluster"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to propagate to AKS resources"
  type        = map(string)
  default     = {}
}