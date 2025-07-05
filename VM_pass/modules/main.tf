# Pobranie konfiguracji bieżącego klienta Azure
data "azurerm_client_config" "current" {}

# Stworzenie grupy zasobów i sieci
resource "azurerm_resource_group" "env_rg" {
  name     = var.resource_group_name
  location = var.location
}
resource "azurerm_virtual_network" "env_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  address_space       = var.vnet_address_space
}
resource "azurerm_subnet" "env_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.env_rg.name
  virtual_network_name = azurerm_virtual_network.env_vnet.name
  address_prefixes     = [var.subnet_address_prefix]
}

# Stworzenie Key Vault
resource "azurerm_key_vault" "env_kv" {
  name                = var.key_vault_name
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    secret_permissions = ["Set", "Get", "Delete", "Purge","List"]
  }
}

# --- ZASOBY DLA MASZYNY LINUX ---
resource "random_password" "linux_vm_password" {
  length           = 20
  special          = true
  override_special = "!@#$%&"
}
resource "azurerm_key_vault_secret" "linux_vm_password_secret" {
  name         = "${var.vm_name}-password"
  value        = random_password.linux_vm_password.result
  key_vault_id = azurerm_key_vault.env_kv.id
}
resource "azurerm_public_ip" "linux_vm_pip" {
  name                = "${var.vm_name}-pip"
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "linux_vm_nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.env_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.linux_vm_pip.id
  }
}
resource "azurerm_linux_virtual_machine" "linux_vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.env_rg.name
  location              = azurerm_resource_group.env_rg.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.linux_vm_nic.id]
  admin_password        = azurerm_key_vault_secret.linux_vm_password_secret.value
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  disable_password_authentication = false
}

# --- ZASOBY DLA MASZYNY WINDOWS ---
resource "random_password" "win_vm_password" {
  length           = 20
  special          = true
  override_special = "!@#$%&"
}
resource "azurerm_key_vault_secret" "win_vm_password_secret" {
  name         = "${var.win_vm_name}-password"
  value        = random_password.win_vm_password.result
  key_vault_id = azurerm_key_vault.env_kv.id
}
resource "azurerm_public_ip" "win_vm_pip" {
  name                = "${var.win_vm_name}-pip"
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
resource "azurerm_network_interface" "win_vm_nic" {
  name                = "${var.win_vm_name}-nic"
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.env_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.win_vm_pip.id
  }
}
resource "azurerm_windows_virtual_machine" "win_vm" {
  name                  = var.win_vm_name
  resource_group_name   = azurerm_resource_group.env_rg.name
  location              = azurerm_resource_group.env_rg.location
  size                  = var.win_vm_size
  admin_username        = var.win_admin_username
  network_interface_ids = [azurerm_network_interface.win_vm_nic.id]
  admin_password        = azurerm_key_vault_secret.win_vm_password_secret.value
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-Azure-Edition"
    version   = "latest"
  }
}


# Stworzenie Network Security Group (NSG)
resource "azurerm_network_security_group" "env_nsg" {
  name                = "${var.resource_group_name}-nsg"
  location            = azurerm_resource_group.env_rg.location
  resource_group_name = azurerm_resource_group.env_rg.name

  # Reguła dla RDP (Windows)
  security_rule {
    name                       = "AllowRDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  # Reguła dla SSH (Linux)
  security_rule {
    name                       = "AllowSSH"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

# Podłączenie stworzonego NSG do naszej podsieci
resource "azurerm_subnet_network_security_group_association" "env_nsg_assoc" {
  subnet_id                 = azurerm_subnet.env_subnet.id
  network_security_group_id = azurerm_network_security_group.env_nsg.id
}