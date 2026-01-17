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
    name     = "vm-resource-group-1701"
    location = "north europe"
}

# create a virtual network
resource "azurerm_virtual_network" "example" {
    name                = "vm-vnet-1701"
    address_space       = ["10.0.0.0/16"]
    location            = "north europe"
    resource_group_name = azurerm_resource_group.example.name
}

# create a subnet
resource "azurerm_subnet" "example" {
  name                 = "vm-subnet-1701"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.9.0/24"]
}

# create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip-1701"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# create a network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic-1701"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_version    = "IPv4"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

# create a virtual machine
resource "azurerm_linux_virtual_machine" "example" {
  name                = "example-vm-1701"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_D2alds_v6"
  admin_username      = "username"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.example.id
  ]

  admin_password = "password"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "ubuntu-pro"
    version   = "latest"
  }
}

# create a network security group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg-1701"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# associate the network security group with the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}