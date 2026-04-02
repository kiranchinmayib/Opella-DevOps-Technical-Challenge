output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "vnet_id" {
  description = "Virtual Network ID"
  value       = module.vnet.vnet_id
}

output "subnet_ids" {
  description = "Subnet IDs from VNET module"
  value       = module.vnet.subnet_ids
}

output "storage_account_name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.sa.name
}

output "vm_name" {
  description = "Virtual Machine name"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip" {
  description = "Private IP of VM"
  value       = azurerm_network_interface.nic.private_ip_address
}
