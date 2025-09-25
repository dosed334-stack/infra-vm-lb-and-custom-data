data "azurerm_subnet" "data_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}
data "azurerm_public_ip" "pipdata" {
  name                = var.pip_name
  resource_group_name = var.rg_name
}
