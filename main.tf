terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.112.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "rg-linux-fx-version"
  location = "Central US"
}

resource "azurerm_storage_account" "example" {
  name                     = "stlinuxfxversion"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "example" {
  name                = "asp-linux-fx-version"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_windows_function_app" "example" {
  name                       = "func-linux-fx-version"
  location                   = azurerm_resource_group.example.location
  resource_group_name        = azurerm_resource_group.example.name
  service_plan_id            = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  client_certificate_mode    = "Required"

  site_config {
    ftps_state        = "FtpsOnly"
    use_32_bit_worker = true

    application_stack {
      use_dotnet_isolated_runtime = true
      dotnet_version              = "v8.0"
    }
  }
}
