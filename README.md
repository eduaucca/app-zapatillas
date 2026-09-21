# App Shoes - DevOps & Zero Trust Cloud Architecture
Proyecto personal de infraestructura y despliegue continuo centrado en seguridad, automatizacion y buenas practicas en la nube. 
El objetivo principal de este proyecto es desplegar una aplicacion web en un cluster de Kubernetes en Azure (AKS) conectandose a un Blob Storage privado sin utilizar ninguna credencial estatica ni contraseñas, aplicando una arquitectura Zero Trust real mediante identidades federadas.


## Stack Tecnológico

* **Aplicación:** Node.js (Express).
* **Contenedores:** Docker.
* **CI/CD:** GitHub Actions.
* **Orquestación:** Kubernetes y Helm.
* **Infra Cloud:** Terraform para provisionar clústeres AKS (Azure).
* **Observabilidad:** Prometheus y Grafana.

# Como esta estructurado

- terraform/: Codigo de infraestructura para levantar la red, el grupo de recursos, el cluster AKS (con OIDC habilitado) y el Storage Account privado.
- helm/: Plantillas parametrizadas para desplegar la aplicacion en Kubernetes separando entornos y configurando las anotaciones necesarias para la inyeccion de identidad.
- src/: Aplicacion en Node.js que utiliza el SDK oficial de Azure (DefaultAzureCredential) para autenticarse en el cluster de forma nativa.

# Arquitectura de Seguridad (Zero Trust)

En lugar de guardar una Connection String o claves de acceso en el codigo o en variables de entorno inseguras, el flujo funciona asi:
1. Terraform crea una Managed Identity en Azure y configura el cluster AKS con OpenID Connect (OIDC).
2. Mediante una Federated Identity Credential, se vincula la ServiceAccount de Kubernetes con la identidad de Azure.
3. Al arrancar la aplicacion, el cluster inyecta de forma transparente un token temporal en el Pod.
4. El SDK de Node.js detecta ese token automaticamente y lee las imagenes del Storage Account privado sin exponer ningun secreto.

# Infraestructura (Terraform)

La carpeta `/terraform` contiene la configuración modularizada para desplegar un clúster de Kubernetes en Microsoft Azure (AKS). Para simular los cambios antes de aplicar:

```bash
cd terraform
az login
terraform init
terraform plan
terraform apply

# Despliegue con Helm
helm upgrade --install release-shoes ./helm
