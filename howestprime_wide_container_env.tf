resource "azurerm_container_app_environment" "howestprime" {
  name                       = var.resource_names.azurerm_container_environment_howestprime
  location                   = var.location
  resource_group_name        = azurerm_resource_group.howestprime.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.howestprime.id
}
