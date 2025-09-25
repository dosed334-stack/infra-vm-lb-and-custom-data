resource "azurerm_bastion_host" "bastion" {
  name                = var.bastion_name
  location            = var.bastion_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = var.ipconfig_name
    subnet_id            = data.azurerm_subnet.data_subnet.id
    public_ip_address_id = data.azurerm_public_ip.pipdata.id
  }
}