# jti-infra

## Purpose

The `jti-infra` repository provisions project-specific infrastructure components across JTI environments (`dev`, `qa`, `stage`, and `main`). This infrastructure is designed to support application hosting and cloud service integration.

Infrastructure provisioned through this project is intended to be deployed **into the landing zone environments** prepared and managed by the `jti-landing-zone` repository pipeline.

### This repository makes use of shared infrastructure modules located in the jti-terraform-modules repository for standardized and reusable resource creation.

---

## What It Provisions

The following Azure resources are provisioned based on modular configuration files:

- **Azure Container Registry (ACR)** 
- **Networking**
- **Databases**
- **Web Applications**
- **Common Data Lookups**

All resources are parameterized using `variables.tf`.

The deployed web application securely connects to the MySQL database using a **Private Endpoint (PEP)**, ensuring traffic remains within the Azure Virtual Network boundary.

---

## CI/CD Pipeline

The GitHub Actions pipeline (`pipeline.yml`) supports:

### Actions:

- `plan`
- `apply`
- `destroy`

### Triggers:

- On push to: `dev`, `qa`, `stage`, `main`
- Manually via workflow dispatch

The pipeline includes steps for:

- Terraform linting and validation
- Generating backend config from template
- Remote state initialization
- Plan/apply/destroy logic per environment

---

## Remote State Configuration

Remote state is managed with Azure Storage using `backend-template.conf`:

```hcl
resource_group_name  = "jti-dev-rg"
storage_account_name = "infrastatedev481"
container_name       = "tfstate"
key                  = "jti${ENV}.terraform.tfstate"
```

This ensures isolated, environment-specific state files.

---
