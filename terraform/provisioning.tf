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
  destination_port_ranges      = ["80","22"]
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
}

data "azurerm_image" "image" {
  name                = "debianS0"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

data "azurerm_image" "image1" {
  name                = "debianS1"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

data "azurerm_image" "image2" {
  name                = "debianS2"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

data "azurerm_image" "image3" {
  name                = "debianS3"
  resource_group_name = "${azurerm_resource_group.main.name}"
}

data "azurerm_image" "image4" {
  name                = "debianS4"
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

resource "azurerm_network_interface" "nicS0" {
  name                = "${var.prefix}-nicS0"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers = ["10.0.2.33"]

  ip_configuration {
    name                          = "${var.prefix}-nicS0-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.33"
  }
}

resource "azurerm_network_interface" "nicS01" {
  name                = "${var.prefix}-nicS01"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  network_security_group_id = "${azurerm_network_security_group.main.id}"

  ip_configuration {
    name                          = "${var.prefix}-nicS01-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = "${azurerm_public_ip.pip1.id}"
  }
}

resource "azurerm_network_interface" "nicS1" {
  name                = "${var.prefix}-nicS1"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers = ["10.0.2.33"]

  ip_configuration {
    name                          = "${var.prefix}-nicS1-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.34"
  }
}

resource "azurerm_network_interface" "nicS2" {
  name                = "${var.prefix}-nicS2"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers = ["10.0.2.33"]

  ip_configuration {
    name                          = "${var.prefix}-nicS2-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.35"
  }
}

resource "azurerm_network_interface" "nicS3" {
  name                = "${var.prefix}-nicS3"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers = ["10.0.2.33"]

  ip_configuration {
    name                          = "${var.prefix}-nicS3-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.36"
  }
}

resource "azurerm_network_interface" "nicS4" {
  name                = "${var.prefix}-nicS4"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  dns_servers = ["10.0.2.33"]
    
  ip_configuration {
    name                          = "${var.prefix}-nicS4-ipconf"
    subnet_id                     = "${azurerm_subnet.internal.id}"
    private_ip_address_allocation = "Static"
    private_ip_address = "10.0.2.37"
  }
}

resource "azurerm_virtual_machine" "S0" {
    name                  = "S0"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS01.id}", "${azurerm_network_interface.nicS0.id}"]
    primary_network_interface_id = "${azurerm_network_interface.nicS01.id}"
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-S0"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "S0"
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

resource "azurerm_virtual_machine" "S1" {
    name                  = "S1"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS1.id}"]
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image1.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-S1"
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

resource "azurerm_virtual_machine" "S2" {
    name                  = "S2"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS2.id}"]
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image2.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-S2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "S2"
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

resource "azurerm_virtual_machine" "S3" {
    name                  = "S3"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS3.id}"]
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image3.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-S3"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "S3"
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

resource "azurerm_virtual_machine" "S4" {
    name                  = "S4"
    location              = "${azurerm_resource_group.main.location}"
    resource_group_name   = "${azurerm_resource_group.main.name}"
    network_interface_ids = ["${azurerm_network_interface.nicS4.id}"]
    vm_size               = "Standard_DS1_v2"

   storage_image_reference {
    id="${data.azurerm_image.image4.id}"
  }

  storage_os_disk {
    name              = "${var.prefix}-osdisk-S4"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "S4"
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

