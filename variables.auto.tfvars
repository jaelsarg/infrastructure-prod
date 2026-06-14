azure_subscription_id = "0319098f-364d-4366-93eb-a6c842525d7a"
azure_tenant_id       = "458a15f2-40e3-4fad-880f-68d74c8bdc4a"
location              = "North Europe"

resource_names = {
  azurerm_resource_group_howestprime                 = "howestprime-wide-p-arg"
  azurerm_key_vault_howestprime                      = "howestprime-wide-p-k-v"
  azurerm_container_registry_howestprime             = "howestprimewidepcr1"
  azurerm_message_broker_howestprime                 = "howestprime-wide-p-mb"
  azurerm_key_vault_secret_messagebroker_howestprime = "howestprime-messagebroker-password"
  azurerm_log_analytics_howestprime                  = "howestprime-wide-p-la"
  azurerm_container_environment_howestprime          = "howestprime-wide-p-ce"
  azurerm_managed_identity_howestprime               = "howestprime-wide-p-mi"

  azurerm_postgresql_server_movies_howestprime          = "howestprime-movies-db"
  azurerm_postgresql_server_database_movies_howestprime = "moviesdb"
  azurerm_key_vault_secret_movies_howestprime           = "howestprime-movies-db-password"

  azurerm_service_plan_client_backoffice_howestprime  = "howestprime-backoffice-sp"
  azurerm_linux_web_app_client_backoffice_howestprime = "howestprime-backoffice"

  azurerm_cosmos_mongo_database_ticketing_howestprime = "ticketingdb"
  azurerm_key_vault_secret_ticketing_howestprime      = "howestprime-ticketing-db-password"

  azurerm_service_plan_client_webapp_howestprime  = "howestprime-webapp-sp"
  azurerm_linux_web_app_client_webapp_howestprime = "howestprime-webapp"
}

resource_login_names = {
  howestprime_microservice_movies_db    = "moviesdbuser"
  howestprime_microservice_ticketing_db = "ticketingdbuser"
}

howestprime_allowed_ip_ranges = [
  {
    name             = "allow_all"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "255.255.255.255"
  }
]
