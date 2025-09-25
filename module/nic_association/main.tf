resource "azurerm_network_interface_security_group_association" "nic-nsg-asso" {
  network_interface_id      = data.azurerm_network_interface.data_nic.id
  network_security_group_id = data.azurerm_network_security_group.data_nsg.id
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-pool-asso" {
  network_interface_id    = data.azurerm_network_interface.data_nic.id
  ip_configuration_name   = var.ip_config_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.data_pool.id
}