variable "client_name" { type = string }
variable "location" {
  type    = string
  default = "eastus"
}
variable "vnet_address_space" { type = list(string) }
variable "subnets" {
  type = map(object({ address_prefix = string }))
}
