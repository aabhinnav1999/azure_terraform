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
}

# Create a resource group
resource "azurerm_resource_group" "example" {
    name     = "disk-resource-group-1901"
    location = "north europe"
}

# Create a managed disk
resource "azurerm_managed_disk" "example" {
  name                 = "example-managed-disk-1901"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb        = 128
}

# data "azurerm_managed_disk" "example" {
#   name                = azurerm_managed_disk.example.name
#   resource_group_name = azurerm_resource_group.example.name
# }