output "vnet_id" { value = azurerm_virtual_network.this.id }
output "subnet_ids" { value = { for k, s in azurerm_subnet.this : k => s.id } }
output "nsg_ids" { value = { for k, n in azurerm_network_security_group.this : k => n.id } }
