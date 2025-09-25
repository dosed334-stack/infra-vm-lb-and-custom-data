resource "azurerm_network_interface" "nic1" {
  name = var.nic_name
  location = var.nic_location
  resource_group_name = var.rg_name

  ip_configuration {
    name = var.ip_config_name
    subnet_id = data.azurerm_subnet.data_subnet.id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}