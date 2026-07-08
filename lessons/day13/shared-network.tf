resource "azurerm_resource_group" "shared_network" {
  name     = "shared-network-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "shared_vnet" {
  name                = "shared-network-vnet"
  address_space       = ["10.1.0.0/16"]
  location            = azurerm_resource_group.shared_network.location
  resource_group_name = azurerm_resource_group.shared_network.name
}

resource "azurerm_subnet" "subnet_shared" {
  name                 = "shared-primary-sn"
  resource_group_name  = azurerm_resource_group.shared_network.name
  virtual_network_name = azurerm_virtual_network.shared_vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}
