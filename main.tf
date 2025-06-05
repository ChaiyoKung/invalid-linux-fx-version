terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.32.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  subscription_id = var.subscription_id
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-linux-fx-version"
  location = "Central US"
}

resource "azurerm_storage_account" "example" {
  name                             = "stlinuxfxversion"
  resource_group_name              = azurerm_resource_group.example.name
  location                         = azurerm_resource_group.example.location
  account_tier                     = "Standard"
  account_replication_type         = "LRS"
  cross_tenant_replication_enabled = true
}

resource "azurerm_service_plan" "example" {
  name                = "asp-linux-fx-version"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  os_type             = "Linux"
  sku_name            = "Y1"

  lifecycle {
    ignore_changes = [
      os_type
    ]
  }
}

resource "azurerm_linux_function_app" "example" {
  name                       = "func-linux-fx-version"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  client_certificate_mode    = "Required"

  site_config {
    ftps_state = "FtpsOnly"

    application_stack {
      dotnet_version = "8.0"
    }
  }
}
