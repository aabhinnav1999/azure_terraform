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
    name     = "vnet-resource-group-1801"
    location = "north europe"
}   

# Create a virtual network
resource "azurerm_virtual_network" "example" {
    name                = "demo-vnet-1801"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name   

    # Create subnets here or use separate terraform resources
    
    # subnet {
    #     name           = "subnet1"
    #     address_prefixes = ["10.0.1.0/24"]
    # }

    # subnet {
    #     name           = "subnet2"
    #     address_prefixes = ["10.0.2.0/24"]
    # }
}

resource "azurerm_subnet" "subnet1" {
    name                 = "subnet1"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnet2" {
    name                 = "subnet2"
    resource_group_name  = azurerm_resource_group.example.name
    virtual_network_name = azurerm_virtual_network.example.name
    address_prefixes     = ["10.0.2.0/24"]
}

# Create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip-1801"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# create a bastion host
resource "azurerm_bastion_host" "example" {
  name                = "example-bastion-1801"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  dns_name            = "example-bastion-1801"

  ip_configuration {
    name                 = "example-ip-config-1801"
    subnet_id            = azurerm_subnet.subnet1.id
    public_ip_address_id = azurerm_public_ip.example.id
  }
}