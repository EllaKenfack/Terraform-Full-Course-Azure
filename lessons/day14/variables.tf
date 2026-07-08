variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "region" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"

  validation {
    condition     = contains(["East US", "West Europe", "Southeast Asia"], var.region)
    error_message = "Region must be one of: East US, West Europe, or Southeast Asia."
  }
}

variable "resource_name_prefix" {
  description = "Prefix for resource naming"
  type        = string
  default     = "day14"
}

variable "min_instances" {
  description = "Minimum number of instances in VMSS"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of instances in VMSS"
  type        = number
  default     = 5
}

variable "default_instances" {
  description = "Default number of instances in VMSS"
  type        = number
  default     = 2
}

variable "vnet_address_space" {
  description = "Virtual network address space"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "app_subnet_prefix" {
  description = "Address prefix for application subnet"
  type        = string
  default     = "10.0.0.0/20"
}

variable "mgmt_subnet_prefix" {
  description = "Address prefix for management subnet"
  type        = string
  default     = "10.0.16.0/20"
}

variable "vm_sizes" {
  description = "VM sizes per environment"
  type        = map(string)
  default = {
    dev   = "Standard_B1s"
    stage = "Standard_B2s"
    prod  = "Standard_B2ms"
  }
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Project     = "TerraformAzureCourse"
    Module      = "Day14"
    ManagedBy   = "Terraform"
  }
}
