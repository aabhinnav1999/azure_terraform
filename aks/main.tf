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

resource "azurerm_resource_group" "demo" {
  name     = "aks-1302-tf-rg"
  location = "north europe"
}

# Create an AKS cluster
resource "azurerm_kubernetes_cluster" "demo" {
  name                = "aks-1302-tf-cluster"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  dns_prefix          = "aks-1302-tf-cluster"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2alds_v7"
  }

  identity {
    type = "SystemAssigned"
  }
}   