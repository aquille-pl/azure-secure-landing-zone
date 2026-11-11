client_name        = "clientsmall"
vnet_address_space = ["10.10.0.0/16"]
subnets = {
  workstations = { address_prefix = "10.10.1.0/24" }
  servers      = { address_prefix = "10.10.2.0/24" }
}
