resource "random_password" "movies_db_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_postgresql_flexible_server" "movies_db" {
  name                          = var.resource_names.azurerm_postgresql_movies_db_howestprime
  location                      = azurerm_resource_group.howestprime.location
  resource_group_name           = azurerm_resource_group.howestprime.name
  administrator_login           = var.usernames.movies_db_username
  administrator_password        = random_password.movies_db_password.result
  version                       = "13"
  sku_name                      = "B_Standard_B1ms"
  storage_mb                    = 32768
  backup_retention_days         = 7
  public_network_access_enabled = true
  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_database" "movie_db_database" {
  name       = var.resource_names.azurerm_postgresql_movies_db_database_howestprime
  server_id  = azurerm_postgresql_flexible_server.movies_db.id
  charset    = "utf8"
  depends_on = [azurerm_postgresql_flexible_server.movies_db]
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_ranges" {
  for_each = { for rule in var.howestprime_allowed_ip_ranges : rule.name => rule }

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.movies_db.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address

  depends_on = [azurerm_postgresql_flexible_server.movies_db]
}

resource "azurerm_key_vault_secret" "movies_db_password" {
  name         = var.resource_names.azurerm_postgresql_movies_db_password_howestprime
  value        = random_password.movies_db_password.result
  key_vault_id = azurerm_key_vault.howestprime.id
  depends_on = [
    azurerm_postgresql_flexible_server.movies_db,
    azurerm_postgresql_flexible_server_database.movie_db_database
  ]
}
