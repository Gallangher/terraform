terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "RG_Terraform_Backend"
    storage_account_name = "sttfbackendtest12345"
    container_name       = "tfstate"
    key                  = "test.terraform.tfstate"
  }
} # <-- Ten nawias zamykający jest kluczowy!

provider "azurerm" {
  features {}
  # Poniższą linię odkomentuj i wklej swoje ID, jeśli jej potrzebujesz
  subscription_id = "185e2a1c-5fa3-42b7-affa-a4ece8945fe6"
}
 


# Wywołanie modułu z wszystkimi zmiennymi
module "test_env" {
  source = "../modules"

  # Zmienne sieciowe
  resource_group_name   = var.resource_group_name
  location              = var.location
  vnet_name             = var.vnet_name
  vnet_address_space    = var.vnet_address_space
  subnet_name           = var.subnet_name
  subnet_address_prefix = var.subnet_address_prefix
  
  # Zmienna Key Vault
  key_vault_name = var.key_vault_name

  # Zmienne Linux VM
  vm_name        = var.vm_name
  vm_size        = var.vm_size
  admin_username = var.admin_username
  
  # Zmienne Windows VM
  win_vm_name        = var.win_vm_name
  win_vm_size        = var.win_vm_size
  win_admin_username = var.win_admin_username
}