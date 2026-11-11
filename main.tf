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

module "logging" {
  source              = "./modules/logging"
  name_prefix         = var.client_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_monitor_diagnostic_setting" "nsg" {
  for_each                   = module.network.nsg_ids
  name                       = "diag-to-log-analytics"
  target_resource_id         = each.value
  log_analytics_workspace_id = module.logging.workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
  }
}

module "security" {
  source              = "./modules/security"
  name_prefix         = var.client_name
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "diag-to-log-analytics"
  target_resource_id         = module.security.key_vault_id
  log_analytics_workspace_id = module.logging.workspace_id

  enabled_log {
    category = "AuditEvent"
  }
}
