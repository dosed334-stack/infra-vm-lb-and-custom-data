resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = var.lb_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration
    public_ip_address_id = data.azurerm_public_ip.data_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.lb_pool_name
}

resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.lb_probe_name
  port            = 22
}

resource "azurerm_lb_rule" "lbrule" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.lb_rule
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  backend_address_pool_ids = [azurerm_lb_backend_address_pool.lb_pool.id,]
  probe_id = azurerm_lb_probe.lb_probe.id
  frontend_ip_configuration_name = "PublicIPAddress"
}


