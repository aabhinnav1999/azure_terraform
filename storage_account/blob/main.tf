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
  name     = "demo-resource-group-1201"
  location = "north europe"
}

# Create a storage account
resource "azurerm_storage_account" "example" {
    name                     = "demostorageacct1201"
    resource_group_name      = azurerm_resource_group.example.name
    location                 = azurerm_resource_group.example.location
    account_tier             = "Standard"
    account_replication_type = "LRS"
    access_tier = "Hot"

    public_network_access_enabled = true

}

# Create a blob container
resource "azurerm_storage_container" "example" {
  name                  = "demo-container-1201"
  storage_account_id = azurerm_storage_account.example.id
  # container_access_type = "private"

  # For public access
  container_access_type = "blob"
}

# Create a blob (adding a local file as source)
resource "azurerm_storage_blob" "example" {
    name                   = "demo-blob-1201.jpeg"
    storage_account_name   = azurerm_storage_account.example.name
    storage_container_name = azurerm_storage_container.example.name
    type                   = "Block"
    source = "sherlock.jpeg"
}   

# Output the blob URL
output "blob_url" {
  value = azurerm_storage_blob.example.url
}