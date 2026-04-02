locals {
  tags = {
    environment = "prod"
    owner       = "platform-team"
    criticality = "high"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-prod-eastus"
  location = var.location
}

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

resource "azurerm_storage_account" "sa" {
  name                     = "prodstorage12345"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_replication_type = "GRS"
  account_tier             = "Standard"
}