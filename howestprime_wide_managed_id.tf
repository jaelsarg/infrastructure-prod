resource "azurerm_user_assigned_identity" "keyvaultreader" {
  name                = var.resource_names.azurerm_managed_identity_howestprime
  resource_group_name = azurerm_resource_group.howestprime.name
  location            = azurerm_resource_group.howestprime.location
}

resource "azurerm_role_assignment" "howestprime_mi" {
  scope                = azurerm_key_vault.howestprime.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.keyvaultreader.principal_id
  depends_on           = [azurerm_key_vault.howestprime]
}
