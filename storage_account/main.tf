terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id = "your-subscription-id"
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "demo-resource-group"
  location = "north europe"
}

# Create a storage account
resource "azurerm_storage_account" "example" {
    name                     = "demostorageacct123"
    resource_group_name      = azurerm_resource_group.example.name
    location                 = azurerm_resource_group.example.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
}