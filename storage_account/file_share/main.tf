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
  name     = "fileshare-resource-group-1101"
  location = "north europe"
}

# Create a storage account
resource "azurerm_storage_account" "example" {
    name                     = "filesharestorageacct1101"
    resource_group_name      = azurerm_resource_group.example.name
    location                 = azurerm_resource_group.example.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier = "Hot"
}

# Create a file share
resource "azurerm_storage_share" "example" {
    name                 = "fileshare-1101"
    storage_account_id = azurerm_storage_account.example.id
    quota                = 50
}

# adding a local file
resource "azurerm_storage_share_file" "example" {
  name              = "terraform-file-1101.tf"
  storage_share_url = azurerm_storage_share.example.url
  source            = "main.tf"
}