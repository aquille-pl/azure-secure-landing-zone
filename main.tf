resource "azurerm_resource_group" "this" {
  name     = "rg-${var.client_name}-lz"
  location = var.location
}

module "network" {
  source              = "./modules/network"
  name_prefix         = var.client_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
}
