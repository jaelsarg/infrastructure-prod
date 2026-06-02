resource "azurerm_service_plan" "client_backoffice" {
    name = var.resource_names.azurerm_client_backoffice_service_plan_howestprime
    location = azurerm_resource_group.howestprime.location
    resource_group_name = azurerm_resource_group.howestprime.name
    os_type = "Linux"
    sku_name = "F1"
}

resource "azurerm_linux_web_app" "client_backoffice" {
    name = var.resource_names.azurerm_linux_web_app_client_backoffice_howestprime
    location = azurerm_resource_group.howestprime.location
    resource_group_name = azurerm_resource_group.howestprime.name
    service_plan_id = azurerm_service_plan.client_backoffice.id
    https_only = true
    site_config {
        always_on = false
        minimum_tls_version = "1.2"
        
        application_stack {
            dotnet_version = "10.0"
        }
    }
}

locals {
    howestprime_repo_backoffice = "st-client-backoffice-jaelsargant"

    howestprime-backoffice-gh-action-variables = {
        az_backoffice_webapp = {
            variable_name = "az_backoffice_webapp"
            value = azurerm_linux_web_app.client_backoffice.name
        }

        az_tenant_id = {
            variable_name = "az_tenant_id"
            value = var.howestprime_tenant_id
        }

        az_resource_group = {
            variable_name = "az_resource_group"
            value = azurerm_resource_group.howestprime.name
        }

        az_subscription_id = {
            variable_name = "az_subscription_id"
            value = var.howestprime_subscription_id
        }
    }

    howestprime-backoffice-gh-action-secrets = {
        howestprime_wide_ci_service_principal = {
            secret_name = "howestprime_wide_ci_service_principal"
            value = azuread_application.github_cicd.client_id
        }

        howestprime_wide_ci_service_principal_password = {
            secret_name = "howestprime_wide_ci_service_principal_password"
            value = azuread_application_password.github_cicd_password.value
        }
    }
}

resource "github_actions_variable" "howestprime_backoffice" {
    for_each = local.howestprime-backoffice-gh-action-variables
    repository = local.howestprime_repo_backoffice
    variable_name = each.value.variable_name
    value = each.value.value
    depends_on = [ azurerm_container_app_environment.howestprime ]
}

resource "github_actions_secret" "howestprime_backoffice" {
    for_each = local.howestprime-backoffice-gh-action-secrets
    repository = local.howestprime_repo_backoffice
    secret_name = each.value.secret_name
    plaintext_value = each.value.value
    depends_on = [ azurerm_container_app_environment.howestprime ]
}