resource "azurerm_service_plan" "client_webapp" {
    name = var.resource_names.azurerm_service_plan_client_webapp_howestprime
    location = azurerm_resource_group.howestprime.location
    resource_group_name = azurerm_resource_group.howestprime.name
    os_type = "Linux"
    sku_name = "F1"
}

resource "azurerm_linux_web_app" "client_webapp" {
    name = var.resource_names.azurerm_linux_web_app_client_webapp_howestprime
    location = azurerm_resource_group.howestprime.location
    resource_group_name = azurerm_resource_group.howestprime.name
    service_plan_id = azurerm_service_plan.client_webapp.id
    site_config {
        always_on = false
        minimum_tls_version = "1.2"

        application_stack {
            docker_image_name = "howestprime-client-webapp:latest"
            docker_registry_url = "https://hcr.technet.howest.be"
        }

        cors {
            allowed_origins = ["*"]
        }
    }

    app_settings = {
        DOCKER_REGISTRY_URL = "https://hcr.technet.howest.be"
        WEBSITES_ENABLE_APP_SERVICE_STORAGE = "false"
        VITE_APP_TICKETING_API_URL = "https://microservice-ticketing.mangowater-d287b693.northeurope.azurecontainerapps.io"
        VITE_APP_MOVIES_BASE_API_URL = "https://microservice-movies.mangowater-d287b693.northeurope.azurecontainerapps.io"
    }
}