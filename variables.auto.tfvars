howestprime_subscription_id = "0319098f-364d-4366-93eb-a6c842525d7a"
howestprime_tenant_id       = "458a15f2-40e3-4fad-880f-68d74c8bdc4a"
location                    = "North Europe"
resource_names = {
  azurerm_resource_group_howestprime        = "howestprime-wide-p-arg"
  azurerm_key_vault_howestprime             = "howestprime-wide-p-k-v"
  azurerm_container_registry_howestprime    = "howestprimewidepcr1"
  azurerm_message_broker_howestprime        = "howestprime-wide-p-mb"
  azurerm_log_analytics_howestprime         = "howestprime-wide-p-la"
  azurerm_container_environment_howestprime = "howestprime-wide-p-ce"
  azurerm_managed_identity_howestprime      = "howestprime-wide-p-mi"
  azurerm_postgresql_movies_db_howestprime  = "howestprime-movies-db"
}
usernames = {
  movies_db_username = "moviesdbuser"
}

howestprime_allowed_ip_ranges = [
  {
    name             = "allow_all"
    start_ip_address = "0.0.0.0"
    end_ip_address   = "255.255.255.255"
  }
]
