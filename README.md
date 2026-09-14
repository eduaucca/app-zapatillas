# App Zapatillas - DevOps \& Cloud Infra

Este repositorio contiene la infraestructura, el ciclo de despliegue y el código de una aplicación web (Node.js). El objetivo principal del proyecto es aplicar el enfoque de Infraestructura como Código (IaC) y automatizar el ciclo de vida completo de la aplicación.

## Stack Tecnológico

* **Aplicación:** Node.js (Express).
* **Contenedores:** Docker.
* **CI/CD:** GitHub Actions.
* **Orquestación:** Kubernetes y Helm.
* **Infra Cloud:** Terraform para provisionar clústeres AKS (Azure).
* **Observabilidad:** Prometheus y Grafana.

## Estructura del repositorio

* `.github/workflows/`: Pipeline de CI para construir y subir la imagen.
* `terraform/`: Ficheros `.tf` para levantar la infraestructura en Azure.
* `helm/`: Plantillas de Helm para desplegar en K8s.
* `src/` y `Dockerfile`: Código fuente de la app y su receta de contenedor.

## Flujo del proyecto

### 1\. Infraestructura (Terraform)

La carpeta `/terraform` contiene la configuración modularizada para desplegar un clúster de Kubernetes en Microsoft Azure (AKS). Para simular los cambios antes de aplicar:

```bash
cd terraform
az login
terraform init
terraform plan

