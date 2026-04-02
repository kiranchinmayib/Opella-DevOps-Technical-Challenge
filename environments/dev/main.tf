locals {
  tags = {
    environment = "dev"
    owner       = "platform-team"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-dev-eastus"
  location = var.location
}

module "vnet" {
  source              = "../../modules/vnet"
  name                = "vnet-dev"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  address_space = ["10.0.0.0/16"]

  subnets = {
    app = {
      address_prefixes = ["10.0.1.0/24"]
    }
    db = {
      address_prefixes = ["10.0.2.0/24"]
    }
  }

  tags = local.tags
}

resource "azurerm_storage_account" "sa" {
  name                     = "devstorage12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}