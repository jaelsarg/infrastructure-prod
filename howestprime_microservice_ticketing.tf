resource "azurerm_cosmosdb_account" "ticketing" {
    name = var.resource_login_names.howestprime_microservice_ticketing_db
    location = azurerm_resource_group.howestprime.location
    resource_group_name = azurerm_resource_group.howestprime.name
    offer_type = "Standard"
    kind = "MongoDB"
    capabilities {
      name = "EnableMongo"
    }
    mongo_server_version = "7.0"
    consistency_policy {
        consistency_level = "Session"
    }
    geo_location {
        location = azurerm_resource_group.howestprime.location
        failover_priority = 0
    }
    free_tier_enabled = true
}

resource "azurerm_cosmosdb_mongo_database" "ticketing" {
    name = var.resource_names.azurerm_cosmos_mongo_database_ticketing_howestprime
    resource_group_name = azurerm_resource_group.howestprime.name
    account_name = azurerm_cosmosdb_account.ticketing.name
}

resource "azurerm_key_vault_secret" "howestprime_ticketing_db" {
    name = var.resource_names.azurerm_key_vault_secret_ticketing_howestprime
    value = local.mongo_pwd
    key_vault_id = azurerm_key_vault.howestprime.id
    depends_on = [
        azurerm_role_assignment.howestprime_keyvault_admin,
        azurerm_cosmosdb_account.ticketing,
        azurerm_cosmosdb_mongo_database.ticketing
    ]
}

locals {
    mongo_pwd = regex(
        "mongodb://[^:]+:([^@]+)@",
        azurerm_cosmosdb_account.ticketing.primary_mongodb_connection_string
    ) [0]

    mongo_host = regex(
        "mongodb://[^:]+:[^@]+@([^:]+):",
        azurerm_cosmosdb_account.ticketing.primary_mongodb_connection_string
    ) [0]

    mongo_port = regex(
        "mongodb://[^:]+:[^@]+@[^:]+:(\\d+)", 
        azurerm_cosmosdb_account.ticketing.primary_mongodb_connection_string
    )[0]

    mongo_options = regex(
        "mongodb://[^:]+:[^@]+@[^:]+:\\d+/\\?([^#]+)", 
        azurerm_cosmosdb_account.ticketing.primary_mongodb_connection_string
    )[0]

    ticketing_documentdb_password_uri = regex(
        "(https://[^/]+/secrets/[^/]+)", 
        azurerm_key_vault_secret.howestprime_ticketing_db.id
    )[0]

    ticketing_messagebroker_password_uri = regex(
        "(https://[^/]+/secrets/[^/]+)", 
        azurerm_key_vault_secret.howestprime_wide_p_messagebroker.id
    )[0]
    
    howestprime_repo_ticketing = "st-microservice-ticketing-jaelsargant"

    howestprime-ticketing-gh-action-variables = {
        howestprime_wide_messagebroker_login = {
            variable_name = "howestprime_wide_p_messagebroker_login"
            value = data.cloudamqp_credentials.local-admin.username
        }

        howestprime_wide_p_messagebroker_password_uri = {
            variable_name = "howestprime_wide_p_messagebroker_password_uri"
            value = local.ticketing_messagebroker_password_uri
        }

        howestprime_wide_p_messagebroker_uri = {
            variable_name = "howestprime_wide_p_messagebroker_hostname"
            value = cloudamqp_instance.howestprime.host
        }

        howestprime_wide_p_messagebroker_vhost = {
            variable_name = "howestprime_wide_p_messagebroker_vhost"
            value = cloudamqp_instance.howestprime.vhost
        }

        howestprime_ticketing_p_asyncapi_uri = {
            variable_name = "howestprime_ticketing_p_asyncapi_uri"
            value = "config/asyncapi.yaml"
        }

        howestprime_ticketing_p_webapi_host = {
            variable_name = "howestprime_ticketing_p_webapi_host"
            value = "0.0.0.0"
        }

        howestprime_ticketing_p_webapi_port = {
            variable_name = "howestprime_ticketing_p_webapi_port"
            value = "8000"
        }

        howestprime_ticketing_p_documentdb_login = {
            variable_name = "howestprime_ticketing_p_documentdb_login"
            value = var.resource_login_names.howestprime_microservice_ticketing_db
        }

        howestprime_ticketing_p_documentdb_port = {
            variable_name = "howestprime_ticketing_p_documentdb_port"
            value = local.mongo_port
        }

        howestprime_ticketing_p_documentdb_host = {
            variable_name = "howestprime_ticketing_p_documentdb_host"
            value = local.mongo_host
        }

        howestprime_ticketing_p_documentdb_options = {
            variable_name = "howestprime_ticketing_p_documentdb_options"
            value = local.mongo_options
        }

        howestprime_ticketing_p_documentdb_protocol = {
            variable_name = "howestprime_ticketing_p_documentdb_protocol"
            value = "mongodb"
        }

        howestprime_ticketing_p_documentdb_password_uri = {
            variable_name = "howestprime_ticketing_p_documentdb_password_uri"
            value = local.ticketing_documentdb_password_uri
        }

        howestprime_ticketing_p_documentdb_db = {
            variable_name = "howestprime_ticketing_p_documentdb_db"
            value = azurerm_cosmosdb_mongo_database.ticketing.name
        }

        howestprime_wide_keyvault_uri = {
            variable_name = "howestprime_wide_keyvault_uri"
            value = azurerm_key_vault.howestprime.vault_uri
        }

        howestprime_wide_mi_keyvaultreader_uri = {
            variable_name = "howestprime_wide_mi_keyvaultreader_uri"
            value = azurerm_user_assigned_identity.keyvaultreader.id
        }

        az_tenant_id = {
            variable_name = "az_tenant_id"
            value = var.azure_tenant_id
        }

        az_subscription_id = {
            variable_name = "az_subscription_id"
            value = var.azure_subscription_id
        }

        az_resource_group = {
            variable_name = "az_resource_group"
            value = azurerm_resource_group.howestprime.name
        }

        az_container_registry = {
            variable_name = "az_container_registry"
            value = azurerm_container_registry.howestprime.login_server
        }

        az_container_environment = {
            variable_name = "az_container_environment"
            value = azurerm_container_app_environment.howestprime.name
        }
    }

    howestprime-ticketing-gh-action-secrets = {
        howestprime_wide_ci_service_principal = {
            secret_name = "howestprime_wide_ci_service_principal"
            value = azuread_application.github_ci_app.client_id
        }

        howestprime_wide_ci_service_principal_password = {
            secret_name = "howestprime_wide_ci_service_principal_password"
            value = azuread_application_password.github_ci_app_password.value
        }
    }
}

resource "github_actions_variable" "howestprime_ticketing" {
    for_each = local.howestprime-ticketing-gh-action-variables
    repository = local.howestprime_repo_ticketing
    variable_name = each.value.variable_name
    value = each.value.value
    depends_on = [
        azurerm_cosmosdb_account.ticketing,
        azurerm_cosmosdb_mongo_database.ticketing
    ]
}

resource "github_actions_secret" "howestprime_ticketing" {
    for_each = local.howestprime-ticketing-gh-action-secrets
    repository = local.howestprime_repo_ticketing
    secret_name = each.value.secret_name
    plaintext_value = each.value.value
    depends_on = [
        azurerm_cosmosdb_account.ticketing,
        azurerm_cosmosdb_mongo_database.ticketing
    ]
}