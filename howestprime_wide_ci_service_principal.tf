resource "azuread_application" "github_ci_app" {
  display_name = "howestprime-github-cicd"
}

resource "time_rotating" "github_ci_app_rotation" {
  rotation_days = 180
}

resource "azuread_application_password" "github_ci_app_password" {
  application_id = azuread_application.github_ci_app.id
  display_name = "Github CI/CD client secret (rotating 180d)"
  rotate_when_changed = {
    rotation = time_rotating.github_ci_app_rotation.id
  }
}

resource "azuread_service_principal" "github_ci_app_sp" {
  client_id = azuread_application.github_ci_app.client_id
  owners = [
    var.service_principal_terraform_sp_id
  ]
}

// Allows pipeline to push docker images to container registry
resource "azurerm_role_assignment" "github_ci_app_role_acr_push" {
  role_definition_name = "AcrPush"
  scope = azurerm_container_registry.howestprime.id
  principal_id = azuread_service_principal.github_ci_app_sp.object_id
  depends_on = [ azurerm_key_vault.howestprime ]
}

// Enables pipeline to manage container apps and relate resources within the resource group
resource "azurerm_role_assignment" "github_ci_app_role_contributor" {
  role_definition_name = "Contributor"
  scope = azurerm_resource_group.howestprime.id
  principal_id = azuread_service_principal.github_ci_app_sp.object_id
  depends_on = [ azurerm_key_vault.howestprime ]
}
