resource "random_pet" "lb_hostname" {
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_naming.rg_name
  location = var.region
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "test" {
  name                = local.resource_naming.vnet_name
  address_space       = local.network_config.vnet_address_space
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags
}

resource "azurerm_subnet" "app_subnet" {
  name                 = local.resource_naming.app_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = [local.network_config.app_subnet_prefix]
}

resource "azurerm_subnet" "mgmt_subnet" {
  name                 = local.resource_naming.mgmt_subnet
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.test.name
  address_prefixes     = [local.network_config.mgmt_subnet_prefix]
}

resource "azurerm_network_security_group" "myNSG" {
  name                = local.resource_naming.nsg_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.common_tags

  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "myNSG" {
  subnet_id                 = azurerm_subnet.app_subnet.id
  network_security_group_id = azurerm_network_security_group.myNSG.id
}


# A public IP address for the load balancer
resource "azurerm_public_ip" "example" {
  name                = local.resource_naming.pip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  domain_name_label   = "${azurerm_resource_group.rg.name}-${random_pet.lb_hostname.id}"
  tags                = local.common_tags
}

# A load balancer with a frontend IP configuration and a backend address pool
resource "azurerm_lb" "example" {
  name                = local.resource_naming.lb_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  tags                = local.common_tags

  frontend_ip_configuration {
    name                 = "myPublicIP"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_lb_backend_address_pool" "bepool" {
  name            = "myBackendAddressPool"
  loadbalancer_id = azurerm_lb.example.id
 
}

#set up load balancer rule from azurerm_lb.example frontend ip to azurerm_lb_backend_address_pool.bepool backend ip port 80 to port 80
resource "azurerm_lb_rule" "example" {
  name                           = "http"
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.bepool.id]
  probe_id                       = azurerm_lb_probe.example.id
}

#set up load balancer probe to check if the backend is up
resource "azurerm_lb_probe" "example" {
  name            = "http-probe"
  loadbalancer_id = azurerm_lb.example.id
  protocol        = "Http"
  port            = 80
  request_path    = "/"
}

#add lb nat rules to allow ssh access to the backend instances
resource "azurerm_lb_nat_rule" "ssh" {
  name                           = "ssh"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.example.id
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 22
  frontend_ip_configuration_name = "myPublicIP"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.bepool.id
}

resource "azurerm_public_ip" "natgwpip" {
  name                = "${local.resource_naming.nat_gw_name}-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]
  tags                = local.common_tags
}

resource "azurerm_nat_gateway" "example" {
  name                    = local.resource_naming.nat_gw_name
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = local.common_tags
}

resource "azurerm_subnet_nat_gateway_association" "example" {
  subnet_id      = azurerm_subnet.app_subnet.id
  nat_gateway_id = azurerm_nat_gateway.example.id
}

resource "azurerm_nat_gateway_public_ip_association" "example" {
  public_ip_address_id = azurerm_public_ip.natgwpip.id
  nat_gateway_id       = azurerm_nat_gateway.example.id
}