resource "cloudamqp_instance" "howestprime" {
  name = var.resource_names.azurerm_message_broker_howestprime
  plan = "lemming"
  region = "amazon-web-services::eu-west-1"
}

data "cloudamqp_credentials" "local-admin" {
  instance_id = cloudamqp_instance.howestprime.id
}

resource "azurerm_key_vault_secret" "howestprime_wide_p_messagebroker" {
  name = var.resource_names.azurerm_key_vault_secret_messagebroker_howestprime
  value = data.cloudamqp_credentials.local-admin.password
  key_vault_id = azurerm_key_vault.howestprime.id
  depends_on = [azurerm_role_assignment.howestprime_keyvault_admin]
}
