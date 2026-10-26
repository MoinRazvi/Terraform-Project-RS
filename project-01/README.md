# Terraform - Project 01
## AWS Infrastructure Provisioning & Drift Detection

**Project:** Terraform Project 01  
**Category:** Infrastructure as Code (IaC)  
**Cloud Provider:** Amazon Web Services (AWS)  
**IaC Tool:** Terraform  
**Status:** Completed  
**Focus:** Infrastructure provisioning, lifecycle management, state management, and configuration drift detection

---

## 1. Project Overview

This project demonstrates how to provision and manage AWS infrastructure using Terraform, following Infrastructure as Code (IaC) principles.

The objective was to provision a VPC with two subnets and deploy an EC2 instance in each subnet. I then explored Terraform lifecycle management and configuration drift by modifying an EC2 instance manually through the AWS Management Console and examining how Terraform identifies the difference between the declared configuration and the actual infrastructure.

This lab establishes the foundation for managing cloud infrastructure in a repeatable, controlled, and auditable manner.

## 2. Objectives

- Provision AWS infrastructure using Terraform.
- Define infrastructure declaratively using `.tf` configuration files.
- Understand the relationship between Terraform configuration, state, and actual AWS resources.
- Implement Terraform lifecycle rules such as `prevent_destroy` and `ignore_changes`.
- Simulate configuration drift through a manual AWS console modification.
- Use Terraform plans to identify infrastructure differences.
- Organize Terraform project files using Git and GitHub.
- Apply Git hygiene practices to prevent publishing sensitive variables and generated Terraform files.

## 3. Architecture

```text
                 Terraform Configuration
                 ┌──────────────────────┐
                 │       main.tf        │
                 │     variables.tf     │
                 │      outputs.tf      │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │  Terraform Workflow  │
                 │ init / plan / apply  │
                 └──────────┬───────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │      AWS VPC         │
                 │                      │
                 │  ┌────────────────┐  │
                 │  │   SUBNET-A     │  │
                 │  │    SERVER-A    │  │
                 │  └────────────────┘  │
                 │                      │
                 │  ┌────────────────┐  │
                 │  │   SUBNET-B     │  │
                 │  │    SERVER-B    │  │
                 │  └────────────────┘  │
                 └──────────────────────┘
                            │
                            ▼
                 ┌──────────────────────┐
                 │   Drift Detection    │
                 │ Terraform Plan vs   │
                 │ Actual AWS State    │
                 └──────────────────────┘
```

*Conceptual architecture of the lab; subnet CIDRs and additional networking components are intentionally omitted.*

## 4. Infrastructure Components

| Component | Purpose |
|---|---|
| AWS VPC | Provides an isolated virtual network for the lab. |
| SUBNET-A | Hosts SERVER-A. |
| SUBNET-B | Hosts SERVER-B. |
| SERVER-A | EC2 instance used to demonstrate configuration drift. |
| SERVER-B | Second EC2 instance in the other subnet. |
| Terraform configuration | Defines the intended infrastructure. |
| Terraform state | Records Terraform's mapping of managed resources to real infrastructure. |
| Terraform lifecycle rules | Control resource replacement, destruction, and selected attribute changes. |

## 5. Repository Structure

```text
Terraform-Project-RS/
├── .gitignore
└── project-01/
    ├── .gitignore
    ├── .terraform.lock.hcl
    ├── README.md
    ├── Task-01.md
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

### File responsibilities

- **`main.tf`** — Defines the AWS resources and Terraform configuration.
- **`variables.tf`** — Declares input variables, including the AWS region configuration.
- **`outputs.tf`** — Defines values to display after Terraform operations.
- **`Task-01.md`** — Contains the original lab task notes.
- **`.terraform.lock.hcl`** — Locks provider selections to support consistent provider installations.
- **`.gitignore`** — Excludes local Terraform data and generated files from Git tracking.
- **`README.md`** — Documents the project architecture, implementation, and learnings.

## 6. Implementation Workflow

### Step 1: Initialize Terraform

```bash
terraform init
```

Initializes the working directory, downloads the required providers, and prepares Terraform for subsequent operations.

### Step 2: Validate the configuration

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

### Step 3: Review the execution plan

```bash
terraform plan
```

Previews the proposed infrastructure changes before making changes to AWS.

### Step 4: Provision the infrastructure

```bash
terraform apply
```

Creates the resources defined in the Terraform configuration after reviewing and approving the proposed changes.

### Step 5: Inspect the managed infrastructure

```bash
terraform state list
```

Lists the resource addresses recorded in Terraform state.

```bash
terraform show
```

Displays a human-readable representation of the current state.

## 7. Terraform Lifecycle Management

This lab explores two important Terraform lifecycle settings.

### `prevent_destroy`

Example:

```hcl
lifecycle {
  prevent_destroy = true
}
```

**Purpose:** Prevents Terraform from planning destruction of a resource while this lifecycle rule is present in its configuration.

**Practical use cases:**
- Protecting critical databases.
- Reducing the risk of accidental destruction of important infrastructure.
- Adding a guardrail for resources that require additional approval before removal.

**Important:** `prevent_destroy` is not a backup mechanism and does not protect against manual deletion in AWS. Removing the resource configuration or the lifecycle rule can also change the protection behavior.

### `ignore_changes`

Example:

```hcl
lifecycle {
  ignore_changes = [
    # Specify the attribute to ignore.
  ]
}
```

**Purpose:** Tells Terraform to disregard changes to selected resource attributes when planning updates to an existing resource.

**Practical use cases:**
- Allowing another approved system to manage selected attributes.
- Avoiding unnecessary updates to attributes intentionally managed outside Terraform.
- Supporting environments with clearly defined shared ownership.

**Important:** `ignore_changes` should be applied selectively. Ignoring an attribute does not reconcile its actual value with the declared configuration.

## 8. Configuration Drift Detection

### What is configuration drift?

Configuration drift occurs when the actual infrastructure differs from the configuration or values Terraform expects to manage.

Drift can arise from:

- Manual changes in the AWS Management Console.
- Changes made by scripts or automation outside Terraform.
- Updates performed by other infrastructure management tools.

### Lab scenario

1. Provisioned SERVER-A with the configured instance type `t3.micro`.
2. Modified SERVER-A manually in the AWS Management Console to use `t3.small`.
3. Used Terraform to examine the difference between the declared configuration and the actual infrastructure.
4. Evaluated how Terraform lifecycle settings influence the resulting plan.

### Commands for drift investigation

```bash
terraform plan -refresh-only
```

Refreshes Terraform's view of managed resources and proposes state updates reflecting observed infrastructure changes. Review the plan before applying it.

```bash
terraform plan
```

Evaluates the configuration against the refreshed view of the infrastructure and identifies proposed corrective changes, subject to lifecycle rules.

### Expected behavior

If the instance type is configured as `t3.micro` and the actual instance type is `t3.small`, Terraform will generally propose restoring the configured value unless the attribute is ignored or other configuration details change the outcome.

If the instance type is covered by `ignore_changes`, Terraform may leave that difference uncorrected.

The actual plan depends on the resource configuration, provider behavior, and applicable lifecycle rules.

**Key distinction:** `terraform plan -refresh-only` helps inspect and record observed changes in state; `terraform plan` evaluates the desired configuration and proposes changes to reconcile differences.

## 9. Git and GitHub Practices

The project is maintained in the repository:

[Terraform-Project-RS on GitHub](https://github.com/MoinRazvi/Terraform-Project-RS)

The project is organized under `project-01/` to support the daily Terraform learning series.

### Files that should be committed

- Terraform configuration files (`.tf`).
- `.terraform.lock.hcl`.
- Project documentation (`README.md`, `Task-01.md`).
- Appropriate `.gitignore` files.

### Files that should not be committed

- `.terraform/` provider and working-directory data.
- Terraform state files such as `terraform.tfstate`.
- State backup files such as `terraform.tfstate.backup`.
- Variable files containing environment-specific values or secrets, such as `terraform.tfvars`.
- Generated plan files such as `tfplan`.
- Credentials, private keys, and other secrets.

Terraform state may contain sensitive values. Keep it in appropriately secured storage, with access controls and encryption suitable for the environment.

## 10. Key Learnings

Through this lab, I practiced:

1. Declarative infrastructure provisioning with Terraform.
2. Structuring Terraform configuration across multiple files.
3. The purpose of initialization, validation, planning, and application.
4. The relationship between Terraform configuration, state, and live infrastructure.
5. The role of lifecycle rules in controlling resource management.
6. Detecting configuration drift caused by manual cloud changes.
7. Differentiating state refresh from configuration reconciliation.
8. Organizing infrastructure code in Git and GitHub while excluding generated and sensitive files.

## 11. Production Considerations

For production environments, I would extend this implementation with:

- Remote state storage in a secured S3 bucket.
- State locking appropriate to the selected Terraform backend and version.
- Encryption at rest and least-privilege IAM access.
- Separate configuration and state for development, staging, and production.
- Pull-request reviews and Terraform plan review before applying changes.
- Automated validation and policy or security checks in CI/CD.
- Explicit controls for resource deletion and changes to critical infrastructure.
- Drift monitoring and documented remediation procedures.
- Secret management outside source control.

These are recommended future enhancements, not claims that every item has already been implemented in this lab.

## 12. Conclusion

Project 01 established a practical foundation for AWS infrastructure provisioning and Terraform lifecycle management. By introducing a manual EC2 instance modification, the lab demonstrated why infrastructure drift must be identified and assessed before corrective changes are applied.

The project also reinforced the importance of keeping infrastructure code version-controlled, documentation organized, and generated Terraform data out of the source repository.

This is the first project in my ongoing Terraform daily learning series. Each subsequent project will build on these fundamentals through additional infrastructure, state management, automation, security, and operational scenarios.

---

**Project 01 — AWS Infrastructure Provisioning & Drift Detection**

*Learning through hands-on implementation, controlled experimentation, and infrastructure-as-code best practices.*

