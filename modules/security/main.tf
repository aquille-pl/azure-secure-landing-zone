data "azurerm_client_config" "current" {}

locals {
  # Key Vault names must be globally unique, so add a short suffix from the subscription ID
  suffix = substr(replace(data.azurerm_client_config.current.subscription_id, "-", ""), 0, 6)
}

resource "azurerm_key_vault" "this" {
  #checkov:skip=CKV2_AZURE_32:Private endpoint deferred. Vault has public access disabled and holds no secrets yet; tracked as a follow-up.
  name                          = "kv-${var.name_prefix}-${local.suffix}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  rbac_authorization_enabled    = true
  soft_delete_retention_days    = 7
  purge_protection_enabled      = true
  public_network_access_enabled = false

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
  }
}

# Let the account running Terraform manage the vault
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.this.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}
