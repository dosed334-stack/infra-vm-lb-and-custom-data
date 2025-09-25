module "rg" {
  source      = "../../module/resource_group"
  rg_name     = "rg00"
  rg_location = "westus"
}
module "vnet" {
  depends_on    = [module.rg]
  source        = "../../module/vnet"
  vnet_name     = "vnet00"
  vnet_location = "westus"
  rg_name       = "rg00"
  address_space = ["10.0.0.0/16"]
}
module "subnet" {
  depends_on       = [module.rg, module.vnet]
  source           = "../../module/subnet"
  subnet_name      = "subnet00"
  vnet_name        = "vnet00"
  rg_name          = "rg00"
  address_prefixes = ["10.0.1.0/24"]
}
module "bastionsubnet" {
  depends_on       = [module.rg, module.vnet]
  source           = "../../module/subnet"
  subnet_name      = "AzureBastionSubnet"
  vnet_name        = "vnet00"
  rg_name          = "rg00"
  address_prefixes = ["10.0.2.0/27"]
}
module "pip" {
  depends_on        = [module.rg, ]
  source            = "../../module/public_ip"
  pip_name          = "my_pip"
  pip_location      = "westus"
  rg_name           = "rg00"
  allocation_method = "Static"
}
module "bastionpip" {
  depends_on        = [module.rg, ]
  source            = "../../module/public_ip"
  pip_name          = "bastion_pip"
  pip_location      = "westus"
  rg_name           = "rg00"
  allocation_method = "Static"
}
module "nic" {
  depends_on                    = [module.pip, module.vnet, module.subnet, ]
  source                        = "../../module/network_interface"
  nic_name                      = "nic00"
  nic_location                  = "westus"
  rg_name                       = "rg00"
  ip_config_name                = "internal"
  private_ip_address_allocation = "Dynamic"
  subnet_name                   = "subnet00"
  vnet_name                     = "vnet00"
}
module "nsg" {
  depends_on   = [module.rg]
  source       = "../../module/network_security"
  nsg_name     = "nsg00"
  nsg_location = "westus"
  rg_name      = "rg00"

  
}
module "nic-asso" {
  depends_on     = [module.rg, module.nic, module.lb, module.nsg, ]
  source         = "../../module/nic_association"
  nic_name       = "nic00"
  rg_name        = "rg00"
  nsg_name       = "nsg00"
  ip_config_name = "internal"
  lb_name        = "lb00"
  lb_pool_name   = "lbpool00"
}
module "lb" {
  depends_on                = [module.rg, module.pip]
  source                    = "../../module/load_balancer"
  lb_name                   = "lb00"
  lb_location               = "westus"
  rg_name                   = "rg00"
  frontend_ip_configuration = "PublicIPAddress"
  lb_pool_name              = "lbpool00"
  lb_probe_name             = "lbprobe00"
  lb_rule                   = "lbrule00"
  pip_name                  = "my_pip"
}
module "vm" {
  depends_on     = [module.rg, module.nic]
  source         = "../../module/virtual_machine"
  vm_name        = "vm00"
  vm_location    = "westus"
  rg_name        = "rg00"
  nic_name       = "nic00"
  admin_username = "username"
  admin_password = "password@123"
}
module "bastion" {
  depends_on = [ module.bastionpip, module.subnet, module.vnet ]
  source = "../../module/bastion"
  subnet_name = "AzureBastionSubnet"
  vnet_name = "vnet00"
  rg_name = "rg00"
  pip_name = "bastion_pip"
  bastion_name = "bastion00"
  bastion_location = "westus"
  ipconfig_name = "internal"

}
