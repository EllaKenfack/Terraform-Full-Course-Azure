locals {
  common_tags = merge(
    var.common_tags,
    {
      CreatedAt = timestamp()
    }
  )

  resource_naming = {
    rg_name     = "${var.resource_name_prefix}-rg-${var.environment}"
    vnet_name   = "${var.resource_name_prefix}-vnet-${var.environment}"
    app_subnet  = "${var.resource_name_prefix}-app-subnet-${var.environment}"
    mgmt_subnet = "${var.resource_name_prefix}-mgmt-subnet-${var.environment}"
    nsg_name    = "${var.resource_name_prefix}-nsg-${var.environment}"
    vmss_name   = "${var.resource_name_prefix}-vmss-${var.environment}"
    lb_name     = "${var.resource_name_prefix}-lb-${var.environment}"
    pip_name    = "${var.resource_name_prefix}-pip-${var.environment}"
    nat_gw_name = "${var.resource_name_prefix}-natgw-${var.environment}"
  }

  network_config = {
    vnet_address_space = var.vnet_address_space
    app_subnet_prefix  = var.app_subnet_prefix
    mgmt_subnet_prefix = var.mgmt_subnet_prefix
  }

  vm_sku = lookup(var.vm_sizes, var.environment, var.vm_sizes["dev"])

  nsg_rules = [
    {
      name                       = "allow-http-from-lb"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-https-from-lb"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-ssh-from-lb"
      priority                   = 102
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}
