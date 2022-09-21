# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "vnet"
  resource_group_name = "1-fa54e041-playground-sandbox"
  location            = "Central US"
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "sandbox"
  }
}

resource "azurerm_public_ip" "example" {
    name = "PublicIPTest"
    resource_group_name = azurerm_virtual_network.example.resource_group_name
    location = azurerm_virtual_network.example.location
    allocation_method = "Static"  
    sku = "Standard"
    sku_tier = "Global"
}

resource "azurerm_subnet" "example" {
  name = "snet"
  resource_group_name = azurerm_virtual_network.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "example" {
  name = "MainInterface"
  location = azurerm_virtual_network.example.location
  resource_group_name = azurerm_virtual_network.example.resource_group_name

  ip_configuration {
    name = "test1"
    subnet_id = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

resource "azurerm_virtual_machine" "example" {
    name = "stlab1"
    location = azurerm_virtual_network.example.location
    resource_group_name = azurerm_virtual_network.example.resource_group_name
    network_interface_ids = [azurerm_network_interface.example.id]
    vm_size = "Standard_DS1_v2"
    delete_os_disk_on_termination = true
    delete_data_disks_on_termination = true

    storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
    }
    storage_os_disk {
        name              = "myosdisk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "testlab"
        admin_username = "testadmin"
        admin_password = "Admin01"
    }
     os_profile_linux_config {
        disable_password_authentication = false
    }
    tags = {
        environment = "sandbox"
    }
}