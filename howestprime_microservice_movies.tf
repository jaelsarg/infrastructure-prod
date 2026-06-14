resource "random_password" "movies" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server" "movies" {
  name                          = var.resource_names.azurerm_postgresql_server_movies_howestprime
  location                      = azurerm_resource_group.howestprime.location
  resource_group_name           = azurerm_resource_group.howestprime.name
  administrator_login           = var.resource_login_names.howestprime_microservice_movies_db
  administrator_password        = random_password.movies.result
  version                       = "13"
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  backup_retention_days         = 7
  public_network_access_enabled = true
  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_database" "movies" {
  name       = var.resource_names.azurerm_postgresql_server_database_movies_howestprime
  server_id  = azurerm_postgresql_flexible_server.movies.id
  charset    = "utf8"
  depends_on = [azurerm_postgresql_flexible_server.movies]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_ranges" {
  for_each = { for rule in var.howestprime_allowed_ip_ranges : rule.name => rule }

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.movies.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
  depends_on       = [azurerm_postgresql_flexible_server.movies]
}

resource "azurerm_key_vault_secret" "howestprime_microservice_movies_db" {
  name         = var.resource_names.azurerm_key_vault_secret_movies_howestprime
  value        = random_password.movies.result
  key_vault_id = azurerm_key_vault.howestprime.id
  depends_on = [
    azurerm_postgresql_flexible_server.movies,
    azurerm_postgresql_flexible_server_database.movies
  ]
}

locals {
  howestprime_repo_movies = "st-microservice-movies-jaelsargant"

  dotnet_connection_string = format(
    "Server=%s;Database=%s;Port=%s;User Id={username};Password={password};Ssl Mode=Require;",
    azurerm_postgresql_flexible_server.movies.fqdn,
    azurerm_postgresql_flexible_server_database.movies.name,
    5432
  )

  messagebroker_password_uri = regex(
    "(https://[^/]+/secrets/[^/]+)",
    azurerm_key_vault_secret.howestprime_wide_p_messagebroker.id
  )[0]

  // [0] is used to extract the first match from the regex, which is the entire URI in this case
  psql_password_uri = regex(
    "(https://[^/]+/secrets/[^/]+)",
    azurerm_key_vault_secret.howestprime_microservice_movies_db.id
  )[0]

  howestprime-movies-gh-action-variables = {
    howestprime_movies_p_psql_login = {
      variable_name = "howestprime_movies_p_psql_login"
      value         = var.resource_login_names.howestprime_microservice_movies_db
    }

    howestprime_movies_p_psql_connection_string = {
      variable_name = "howestprime_movies_p_psql_connection_string"
      value         = local.dotnet_connection_string
    }

    howestprime_wide_p_messagebroker_login = {
      variable_name = "howestprime_wide_p_messagebroker_login"
      value         = data.cloudamqp_credentials.local-admin.username
    }

    howestprime_wide_p_keyvault_uri = {
      variable_name = "howestprime_wide_p_keyvault_uri"
      value         = azurerm_key_vault.howestprime.vault_uri
    }

    howestprime_wide_mi_keyvaultreader_uri = {
      variable_name = "howestprime_wide_mi_keyvaultreader_uri"
      value         = azurerm_user_assigned_identity.keyvaultreader.id
    }

    az_tenant_id = {
      variable_name = "az_tenant_id"
      value         = var.azure_tenant_id
    }

    az_subscription_id = {
      variable_name = "az_subscription_id"
      value         = var.azure_subscription_id
    }

    az_resource_group = {
      variable_name = "az_resource_group"
      value         = azurerm_resource_group.howestprime.name
    }

    az_container_registry = {
      variable_name = "az_container_registry"
      value         = azurerm_container_registry.howestprime.login_server
    }

    az_container_environment = {
      variable_name = "az_container_environment"
      value         = azurerm_container_app_environment.howestprime.name
    }

    howestprime_movies_p_sqlsrv_password_uri = {
      variable_name = "howestprime_movies_p_sqlsrv_password_uri"
      value         = local.psql_password_uri
    }

    howestprime_wide_p_messagebroker_password_uri = {
      variable_name = "howestprime_wide_p_messagebroker_password_uri"
      value         = local.messagebroker_password_uri
    }

    howestprime_wide_p_messagebroker_uri = {
      variable_name = "howestprime_wide_p_messagebroker_hostname"
      value         = cloudamqp_instance.howestprime.host
    }

    howestprime_wide_p_messagebroker_vhost = {
      variable_name = "howestprime_wide_p_messagebroker_vhost"
      value         = cloudamqp_instance.howestprime.vhost
    }
  }

  howestprime-movies-gh-action-secrets = {
    howestprime_wide_ci_service_principal = {
      secret_name = "howestprime_wide_ci_service_principal"
      value       = azuread_application.github_ci_app.client_id
    }

    howestprime_wide_ci_service_principal_password = {
      secret_name = "howestprime_wide_ci_service_principal_password"
      value       = azuread_application_password.github_ci_app_password.value
    }
  }
}

resource "github_actions_variable" "howestprime_movies" {
  for_each      = local.howestprime-movies-gh-action-variables
  repository    = local.howestprime_repo_movies
  variable_name = each.value.variable_name
  value         = each.value.value
}

resource "github_actions_secret" "howestprime_movies" {
  for_each        = local.howestprime-movies-gh-action-secrets
  repository      = local.howestprime_repo_movies
  secret_name     = each.value.secret_name
  plaintext_value = each.value.value
}
