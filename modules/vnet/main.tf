locals {
  tags = {
    environment = "prod"
    owner       = "platform-team"
    criticality = "high"
  }
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-prod-eastus"
  location = var.location

  tags = local.tags
}

# VNET (via module — DO NOT duplicate resources)
module "vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-prod"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.1.0.0/16"]

  subnets = {
    app = {
      address_prefixes = ["10.1.1.0/24"]
    }
    db = {
      address_prefixes = ["10.1.2.0/24"]
    }
  }

  tags = local.tags
}

# Storage Account (Production-grade replication)
resource "azurerm_storage_account" "sa" {
  name                     = "prodstorage01" # must be globally unique
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = local.tags
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "nic-${local.tags.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.vnet.subnet_ids["app"]
    private_ip_address_allocation = "Dynamic"
  }

  tags = local.tags
}

# Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-${local.tags.environment}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  size                = "Standard_B1s"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}
