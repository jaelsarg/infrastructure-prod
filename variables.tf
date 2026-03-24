variable "howestprime_subscription_id" {
  type        = string
  description = "The Azure Subscription ID where resources will be deployed."
}

variable "howestprime_tenant_id" {
  type        = string
  description = "The tenant ID"
}

variable "service_principal_terraform_client_id" {
  type        = string
  description = "The client ID of the terraform Service Principal"
}

variable "service_principal_terraform_secret" {
  type        = string
  description = "The client secret for the terraform Service Principal"
}

variable "service_principal_terraform_sp_id" {
  type        = string
  description = "The Principal ID (objectID) of the Service Principal"
}
