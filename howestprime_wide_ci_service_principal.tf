resource "azuread_application" "github_cicd" {
  display_name = "howestprime-github-cicd"
}

resource "time_rotating" "github_cicd_rotation" {
  rotation_days = 180
}

resource "azuread_application_password" "github_cicd_password" {
  application_id = azuread_application.github_cicd.id
  display_name   = "Github CI/CD client secret (rotating 180d)"
  rotate_when_changed = {
    rotation = time_rotating.github_cicd_rotation.id
  }
}

resource "azuread_service_principal" "github_cicd_sp" {
  client_id = azuread_application.github_cicd.client_id
  owners = [
    var.service_principal_terraform_sp_id
  ]
}
