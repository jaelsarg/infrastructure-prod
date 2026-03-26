terraform {
  required_version = "1.14.7"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.61.0"
    }

    cloudamqp = {
      source  = "cloudamqp/cloudamqp"
      version = "~> 1.42"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  subscription_id                = var.howestprime_subscription_id
  tenant_id                      = var.howestprime_tenant_id
  client_id                      = var.service_principal_terraform_client_id
  client_secret                  = var.service_principal_terraform_secret
  resource_providers_to_register = ["Microsoft.App"]
  features {
    key_vault {
      purge_soft_delete_on_destroy          = true
      purge_soft_deleted_secrets_on_destroy = true
    }
  }
}

provider "cloudamqp" {
  apikey = var.cloudamqp_api_key
}
