provider "azurerm" {
}

variable "prefix" {
  default = "mareak_fitecP1"
}

resource "azurerm_resource_group" "main" {
        name = "mareak.fitec.P1.RG"
        location = "eastus"
}

resource "azurerm_network_security_group" "main" {
  name     = "${var.prefix}-webservers"
  location = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_network_security_rule" "web" {
  name                       = "{var.prefix}-http-access-rule"
  network_security_group_name = "${azurerm_network_security_group.main.name}"
  resource_group_name         = "${azurerm_resource_group.main.name}"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}


data "azurerm_image" "image" {
  name                = "debianS1"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_public_ip" "pip1" {
  name                = "${var.prefix}-pip1"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  allocation_method   = "Static"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet-internal"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.main.name}"
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "nicS1" {
  name                = "${var.prefix}-nicS1"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "${var.prefix}-nicS1-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.33"
  }
}

resource "azurerm_network_interface" "nicS2" {
  name                = "${var.prefix}-nicS2"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"

  ip_configuration {
    name                          = "${var.prefix}-nicS2-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.pip1.id}"
  }
}

resource "azurerm_virtual_machine" "S1" {
    name                  = "S1"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS2.id}", "${azurerm_network_interface.nicS1.id}"]
    primary_network_interface_id = "${azurerm_network_interface.nicS2.id}"
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name              = "osdisk-S1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "S1"
    admin_username = "mareak"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
