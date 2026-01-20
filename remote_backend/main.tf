terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 4.0"
    }
  }

    backend "azurerm" {
        resource_group_name   = "demo-resource-group"
        storage_account_name  = "demostorageacct123"
        container_name        = "terraformcontainer"
        key                   = "terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}