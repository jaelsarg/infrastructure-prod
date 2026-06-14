variable "azure_subscription_id" {
  type        = string
  description = "The Azure Subscription ID where resources will be deployed."
  sensitive   = false
}

variable "azure_tenant_id" {
  type        = string
  description = "The tenant ID"
  sensitive   = true
}

variable "service_principal_terraform_client_id" {
  type        = string
  description = "The client ID of the terraform Service Principal"
  sensitive   = true
}

variable "service_principal_terraform_secret" {
  type        = string
  description = "The client secret for the terraform Service Principal"
  sensitive   = true
}

variable "service_principal_terraform_sp_id" {
  type        = string
  description = "The Principal ID (objectID) of the Service Principal"
  sensitive   = true
}

variable "location" {
  type        = string
  description = "Location for all resources"
  sensitive   = false
}

variable "resource_names" {
  type        = map(string)
  description = "Map of resource names to assign to the resources"
  sensitive   = false
}

variable "cloudamqp_api_key" {
  type        = string
  description = "API key for CloudAMQP provider"
  sensitive   = true
}

variable "resource_login_names" {
  type        = map(string)
  description = "Map of usernames to assign to the resources"
  sensitive   = false
}

variable "howestprime_allowed_ip_ranges" {
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
  description = "List allowed IP addresses for documentDB firewall rule"
}

variable "github_access_token" {
  type        = string
  description = "GitHub access token"
  sensitive   = true
}

variable "github_owner_name" {
  type        = string
  description = "GitHub owner name"
  sensitive   = true
}
