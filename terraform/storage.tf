# Creamos el Storage Account para guardar las imagenes
resource "azurerm_storage_account" "store_shoes" {
  name                     = "stshoesprod01" # El nombre debe ser único en todo Azure
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Creamos el contenedor "photos" y lo hacemos privado
resource "azurerm_storage_container" "photos" {
  name                  = "images-shoes"
  storage_account_name  = azurerm_storage_account.store_shoes.name
  container_access_type = "private" 
}

# Creamos la identidad para la app  en Node.js
resource "azurerm_user_assigned_identity" "id_app" {
  name                = "id-app-shoes"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# RBAC: Le damos el rol de "Lector de datos" a la app
resource "azurerm_role_assignment" "permise_read_photos" {
  scope                = azurerm_storage_account.store_shoes.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_user_assigned_identity.id_app.principal_id
}

# Vinculamos Service Account de helm con la id de azure
resource "azurerm_federated_identity_credential" "fic_shoes" {
  name                = "fic-app-shoes"
  resource_group_name = azurerm_resource_group.rg.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.id_app.id
  subject             = "system:serviceaccount:default:shoes-sa"
}
