# Azure Infrastructure Provisioning with Terraform

## Overview

This repository demonstrates a modular and scalable approach to provisioning Azure infrastructure using Terraform.

The solution is designed to showcase:

* Reusable Infrastructure as Code (IaC)
* Multi-environment deployment (Development and Production)
* Secure and maintainable design
* CI integration using GitHub Actions

---

## Architecture

The infrastructure is organized into reusable modules and environment-specific configurations.

### Components

* **VNET Module** – reusable networking layer
* **Environments** – Dev and Prod deployments
* **Additional Resources**

  * Storage Account (Blob)
  * Virtual Machine (Prod)

---

## Repository Structure

```bash
azure-terraform-infra/
├── modules/vnet/
├── environments/dev/
├── environments/prod/
├── .github/workflows/
├── scripts/
├── plan-outputs/
├── .gitignore
└── README.md
```

---

## Design Decisions

### 1. Modular Design

The Virtual Network is implemented as a reusable module:

* Eliminates duplication
* Ensures consistency
* Enables reuse across environments

---

### 2. Environment Separation

Each environment (Dev, Prod):

* Uses separate Resource Groups
* Maintains independent Terraform state
* Allows safe and isolated deployments

---

### 3. Naming Convention

Resources follow a consistent naming pattern:

```bash
<resource>-<environment>-<region>
```

**Examples:**

* vnet-dev-eastus
* rg-prod-eastus

---

### 4. Tagging Strategy

All resources include standardized tags:

```hcl
environment = "dev | prod"
owner       = "platform-team"
costcenter  = "engineering"
```

Purpose:

* Cost tracking
* Governance
* Resource filtering

---

## Terraform Module – VNET

### Features

* Configurable address space
* Dynamic subnet creation using `for_each`
* Optional service endpoints
* Tagging support

### Inputs

| Variable            | Description               |
| ------------------- | ------------------------- |
| name                | VNET name                 |
| location            | Azure region              |
| resource_group_name | Target resource group     |
| address_space       | CIDR range                |
| subnets             | Map of subnet definitions |
| tags                | Resource tags             |

### Outputs

| Output     | Description          |
| ---------- | -------------------- |
| vnet_id    | Virtual Network ID   |
| vnet_name  | Virtual Network name |
| subnet_ids | Map of subnet IDs    |

---

## Environment Configuration

### Development (Dev)

* Region: eastus
* Storage: LRS (cost-optimized)
* Smaller footprint

---

### Production (Prod)

* Region: eastus
* Storage: GRS (high availability)
* Includes Virtual Machine
* Enhanced tagging and governance

---

## Remote State Management

Terraform state is stored in Azure Storage:

Benefits:

* Enables team collaboration
* Prevents state conflicts
* Supports locking and versioning

---

## CI/CD Pipeline

GitHub Actions is used for validation and planning.

### Pipeline Steps

1. Terraform format check
2. Terraform init
3. Terraform validate
4. Terraform plan

### Why no `apply`?

Deployment should be controlled with approvals and not executed automatically in CI.

---

## Code Quality & Security

Tools used:

* `terraform fmt` – formatting
* `terraform validate` – syntax validation
* `tflint` – linting
* `checkov` – security scanning

---

## How to Run

### Prerequisites

* Terraform installed
* Azure CLI authenticated
* Azure subscription

---

### Run Dev Environment

```bash
cd environments/dev
terraform init
terraform plan
```

---

### Run Prod Environment

```bash
cd environments/prod
terraform init
terraform plan
```

---

## Plan Outputs

Terraform plans are stored for review:

```bash
plan-outputs/
├── dev-plan.txt
└── prod-plan.txt
```

---

## Key Considerations

### Resource Groups vs Subscriptions

* Current setup uses Resource Groups for environment separation
* Design supports future expansion to separate subscriptions

---

### CIDR Strategy

* Dev: 10.0.0.0/16
* Prod: 10.1.0.0/16

Prevents overlap and supports future network peering

---

### Security Approach

* SSH key-based VM access
* No hardcoded secrets
* Security scanning integrated in pipeline

---

## Future Improvements

* Network Security Groups (NSG)
* Private endpoints
* Azure Key Vault integration
* Multi-region deployments
* Approval-based deployment pipeline

---

## Summary

This project demonstrates:

* Clean Terraform module design
* Environment isolation
* CI pipeline integration
* Scalable and maintainable infrastructure

The focus is on building infrastructure that is reusable, secure, and production-ready.
