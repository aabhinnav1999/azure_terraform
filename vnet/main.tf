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
    name     = "vnet-resource-group-1401"
    location = "north europe"
}   

# Create a virtual network
resource "azurerm_virtual_network" "example" {
    name                = "demo-vnet-1401"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name   

    # Create subnets
    
    subnet {
        name           = "subnet1"
        address_prefixes = ["10.0.1.0/24"]
    }

    subnet {
        name           = "subnet2"
        address_prefixes = ["10.0.2.0/24"]
    }
}