resource "azurerm_key_vault" "howestprime" {
  name                            = var.resource_names.azurerm_key_vault_howestprime
  resource_group_name             = azurerm_resource_group.howestprime.name
  location                        = var.location
  tenant_id                       = var.howestprime_tenant_id
  sku_name                        = "standard"
  soft_delete_retention_days      = 7
  purge_protection_enabled        = false
  enabled_for_disk_encryption     = true
  enabled_for_deployment          = true
  enabled_for_template_deployment = true
}

resource "azurerm_role_assignment" "howestprime_keyvault_admin" {
  scope                = azurerm_key_vault.howestprime.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = var.service_principal_terraform_sp_id
  depends_on           = [azurerm_key_vault.howestprime]
}
