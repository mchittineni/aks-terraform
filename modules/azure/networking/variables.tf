variable "location" {
  description = "Azure region where the VNet will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group that will host networking resources"
  type        = string
}

variable "vnet_address_space" {
  description = "Address spaces assigned to the Virtual Network"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project identifier used for naming"
  type        = string
}

variable "tags" {
  description = "Optional tags to merge with defaults"
  type        = map(string)
  default     = {}
}
