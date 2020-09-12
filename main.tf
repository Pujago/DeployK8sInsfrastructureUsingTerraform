
terraform {
  backend "azurerm" {

  }
}

provider "azurerm" {
  version         = "~>2.0.0"
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}

resource "azurerm_resource_group" "tf_resource_group" {
  name     = "${var.resource_group}_${var.environment}"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                     = "StudentApplicationImages"
  resource_group_name      = azurerm_resource_group.tf_resource_group.name
  location                 = azurerm_resource_group.tf_resource_group.location
  sku                      = "Premium"
}

resource "azurerm_kubernetes_cluster" "tf_kubernetes_cluster" {
  name                = "${var.cluster_name}_${var.environment}"
  location            = azurerm_resource_group.tf_resource_group.location
  resource_group_name = azurerm_resource_group.tf_resource_group.name
  dns_prefix          = var.dns_prefix

  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  default_node_pool {
    name       = "agentpool"
    node_count = var.node_count
    vm_size    = "Standard_DS1_v2"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = var.environment
  }
}