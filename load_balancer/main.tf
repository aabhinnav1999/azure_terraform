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

# create a resource group
resource "azurerm_resource_group" "example" {
  name     = "1402-lb-rg"
  location = "North Europe"
}

# create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "1402-lb-pip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# create a load balancer
resource "azurerm_lb" "example" {
  name                = "1402-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}