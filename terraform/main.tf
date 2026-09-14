# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-zapatillas-dev"
  location = "westeurope" # Servidores en Europa
}

# Cluster de Kubernetes (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-zapatillas-cluster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akszapatillas"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s" # Tamaño de máquina virtual básico
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
    Project     = "App Zapatillas"
    ManagedBy   = "Terraform"
  }
}
