output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.rg.id
}

output "load_balancer_public_ip" {
  description = "Public IP address of the load balancer"
  value       = azurerm_public_ip.example.ip_address
}

output "load_balancer_fqdn" {
  description = "Fully qualified domain name of the load balancer"
  value       = azurerm_public_ip.example.fqdn
}

output "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.id
}

output "vmss_name" {
  description = "Name of the Virtual Machine Scale Set"
  value       = azurerm_orchestrated_virtual_machine_scale_set.vmss_terraform_tutorial.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.test.id
}

output "app_subnet_id" {
  description = "ID of the application subnet"
  value       = azurerm_subnet.app_subnet.id
}

output "mgmt_subnet_id" {
  description = "ID of the management subnet"
  value       = azurerm_subnet.mgmt_subnet.id
}

output "nsg_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.myNSG.id
}

output "vm_sku_used" {
  description = "VM SKU used based on environment"
  value       = local.vm_sku
}

output "environment" {
  description = "Environment deployed"
  value       = var.environment
}
