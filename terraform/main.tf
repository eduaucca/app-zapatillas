# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-shoes-dev"
  location = "eastus" # Servidores en EE.UU, para limitaciones de regiones
}

# Cluster de Kubernetes (AKS)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-shoes-cluster"
  location            = azurerm_resource_group.rg.location
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksshoes"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2s_v7" # Tamaño de máquina virtual básico
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Development"
    Project     = "App Shoes"
    ManagedBy   = "Terraform"
  }
}
