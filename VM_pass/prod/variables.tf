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
  description = "Przestrze adresowa dla sieci VNet (np. ['10.128.0.0/17'])."
  type        = list(string)
}

variable "subnet_name" {
  description = "Nazwa podsieci."
  type        = string
}

variable "subnet_address_prefix" {
  description = "Prefiks adresowy dla podsieci (np. '10.128.0.0/24')."
  type        = string
}
