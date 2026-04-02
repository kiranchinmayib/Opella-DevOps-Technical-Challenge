# Opella-DevOps-Technical-Challenge
# Azure Infrastructure Provisioning with Terraform

## Overview

This repository demonstrates a modular, scalable, and production-ready approach to provisioning Azure infrastructure using Terraform.

The solution focuses on:

* Reusable Infrastructure as Code (IaC)
* Multi-environment deployment (Dev & Prod)
* Secure and maintainable design
* CI/CD integration using GitHub Actions

---

## Architecture

The infrastructure is structured into reusable modules and environment-specific configurations.

### Key Components

* **Terraform Module**: Azure Virtual Network (VNET)
* **Environments**: Dev and Prod
* **Additional Resources**:

  * Virtual Machine (Linux)
  * Storage Account (Blob)

---

## Repository Structure

```
.
├── modules/
│   └── vnet/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── README.md
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   │
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
│
├── global/
│   ├── provider.tf
│   └── backend.tf
│
├── .github/workflows/
│   └── terraform.yml
│
└── README.md
```

---

## Design Decisions

### 1. Modular Architecture

The VNET is implemented as a reusable module to:

* Avoid duplication
* Ensure consistency across environments
* Enable scalability

### 2. Environment Isolation

* Each environment (Dev, Prod) is deployed in separate **Resource Groups**
* Design allows future extension to **separate subscriptions**

### 3. Naming Convention

Resources follow a structured naming pattern:

```
<resource>-<environment>-<region>
```

Example:

```
vnet-dev-eastus
vm-prod-eastus
```

### 4. Tagging Strategy

All resources are tagged for governance and cost tracking:

* environment
* owner
* costcenter

---

## Terraform Module: VNET

### Features

* Configurable address space
* Dynamic subnet creation using `for_each`
* Tag support
* Reusable across environments

### Inputs

| Name                | Description               |
| ------------------- | ------------------------- |
| name                | VNET name                 |
| location            | Azure region              |
| resource_group_name | Target resource group     |
| address_space       | CIDR block                |
| subnets             | Map of subnet definitions |
| tags                | Resource tags             |

### Outputs

| Name       | Description       |
| ---------- | ----------------- |
| vnet_id    | ID of the VNET    |
| subnet_ids | Map of subnet IDs |

---

## Additional Resources

### Virtual Machine

* Linux VM (Standard_B1s)
* Used for basic compute validation

### Storage Account

* Blob storage enabled
* Used for application/data storage simulation

---

## Remote State Management

Terraform state is stored in Azure Storage:

* Enables team collaboration
* Prevents state conflicts
* Supports locking and versioning

---

## CI/CD Pipeline

Implemented using GitHub Actions.

### Pipeline Stages

1. Checkout code
2. Terraform Init
3. Terraform Validate
4. Terraform Plan

### Future Enhancements

* Add approval gate before `apply`
* Add environment-based deployments
* Integrate security scanning

---

## Code Quality & Security

Tools used:

* `terraform fmt` → formatting
* `terraform validate` → syntax validation
* `tflint` → linting
* `checkov` → security scanning

---

## How to Run

### Prerequisites

* Terraform installed
* Azure CLI authenticated
* Azure subscription

### Steps

```bash
cd environments/dev

terraform init
terraform plan
terraform apply
```

---

## Terraform Plan Output

Include your generated plan output here or as a separate file:

```
terraform plan > plan-output.txt
```

---

## Scalability Considerations

This design supports:

* Multi-region deployments
* Multi-environment setups
* Easy extension to additional modules (AKS, DB, etc.)

---

## Testing Strategy (Optional)

* `terraform validate` for syntax checks
* `terraform plan` for dry-run validation
* Can be extended using Terratest for automated testing

---

## Future Improvements

* Add NSGs and security rules
* Implement private endpoints
* Add Key Vault integration
* Introduce Terraform workspaces or environment pipelines

---

## Summary

This project demonstrates:

* Clean Terraform module design
* Environment separation
* CI/CD integration
* Security and governance best practices

The focus is on building infrastructure that is not only functional, but also maintainable, reusable, and production-ready.

