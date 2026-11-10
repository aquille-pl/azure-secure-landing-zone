terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-lz"
    storage_account_name = "sttfstatelz1472129900"
    container_name       = "tfstate"
    key                  = "landing-zone.tfstate"
    use_azuread_auth     = true
  }
}
