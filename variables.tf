variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  default     = "eastus"
  description = "East US"
}

variable "rgName" {
  default     = "capic03"
  description = "Cloud APIC resource group"
}

variable "deployName" {
  default = "capic03tf"
}