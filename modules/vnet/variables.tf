variable "name" {
  description = "VNET name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "address_space" {
  description = "VNET CIDR range"
  type        = list(string)
}

variable "subnets" {
  description = "Map of subnets"
  type = map(object({
    address_prefixes = list(string)
    service_endpoints = optional(list(string))
  }))
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}