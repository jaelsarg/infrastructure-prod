resource "azurerm_resource_group" "howestprime" {
  name     = var.resource_names["azurerm_resource_group_howestprime"]
  location = var.location
}
