terraform {
  backend "azurerm" {
    # Nazwa grupy zasobów, którą stworzyliśmy dla przechowywania stanu
    resource_group_name  = "rg-terraform-state-test-20250704" 
    
    # Nazwa konta storage, którą stworzyliśmy dla przechowywania stanu
    storage_account_name = "stterraformstate20250704" # <-- Wpisz tutaj swoją unikalną nazwę
    
    # Nazwa kontenera, który stworzyliśmy
    container_name       = "tfstate"
    
    # Nazwa pliku stanu dla Twojej infrastruktury. Możesz ją zostawić.
    key                  = "prod.terraform.tfstate" 
  }
}
