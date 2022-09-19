# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Create a storage account
resource "azurerm_storage_account" "example" {
  name                     = "[storageAccountName]" # Fill in storage account name without spaces & spacial characters e.g. stlab + rand_number = stlab03463546  
  resource_group_name      = "[resourceGroupName]" # Fill in resource group name (find it in Azure portal) e.g. rg-sandbox-000-48n1u
  location                 = "South Central US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version = "TLS1_0"
  enable_https_traffic_only = false

  network_rules {
    default_action = "Allow"
  }

  tags = {
    environment = "sandbox"
  }
}