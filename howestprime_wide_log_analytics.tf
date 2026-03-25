resource "azurerm_log_analytics_workspace" "howestprime" {
  name                = var.resource_names.azurerm_log_analytics_howestprime
  location            = var.location
  resource_group_name = azurerm_resource_group.howestprime.name
}
