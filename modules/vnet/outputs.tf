output "vnet_id" {
  description = "VNET ID"
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "subnet_ids" {
  description = "Subnet IDs map"
  value = {
    for subnet_name, subnet in azurerm_subnet.this :
    subnet_name => subnet.id
  }
}