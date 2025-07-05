# Statyczna konfiguracja backendu dla rodowiska TEST
terraform {
  backend "azurerm" {
    resource_group_name  = "RG_Terraform_Backend"
    storage_account_name = "sttfbackendprod12345" # Pamitaj, aby wstawi swoj unikaln nazw
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "185e2a1c-5fa3-42b7-affa-a4ece8945fe6"
}


# Wywoanie moduu "fabryki rodowisk" z danymi dla PROD
module "PROD_env" {
  source = "../modules"

  # Przekazanie konkretnych wartoci do moduu
  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  vnet_address_space    = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
}
