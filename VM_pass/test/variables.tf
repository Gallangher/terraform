variable "resource_group_name" {
  description = "Nazwa grupy zasobow dla rodowiska."
  type        = string
}

variable "location" {
  description = "Lokalizacja zasobow w Azure."
  type        = string
}

variable "vnet_name" {
  description = "Nazwa sieci wirtualnej."
  type        = string
}

variable "vnet_address_space" {
  description = "Przestrze adresowa dla sieci VNet (np. ['10.0.0.0/17'])."
  type        = list(string)
}

variable "subnet_name" {
  description = "Nazwa podsieci."
  type        = string
}

variable "subnet_address_prefix" {
  description = "Prefiks adresowy dla podsieci (np. '10.0.0.0/24')."
  type        = string
}



variable "key_vault_name" {
  description = "Nazwa dla Key Vault. Musi byc globalnie unikalna."
  type        = string
}
variable "vm_name" {
  description = "Nazwa maszyny wirtualnej Linux."
  type        = string
}
variable "vm_size" {
  description = "Rozmiar maszyny wirtualnej Linux."
  type        = string
  default     = "Standard_B1s"
}
variable "admin_username" {
  description = "Nazwa uzytkownika administracyjnego dla maszyny Linux."
  type        = string
}
variable "win_vm_name" {
  description = "Nazwa maszyny wirtualnej Windows."
  type        = string
}
variable "win_vm_size" {
  description = "Rozmiar maszyny wirtualnej Windows."
  type        = string
  default     = "Standard_B1s"
}
variable "win_admin_username" {
  description = "Nazwa użytkownika administracyjnego dla maszyny Windows."
  type        = string
}