# Terraform Daily Projects — AWS Infrastructure as Code

A hands-on Terraform learning repository focused on provisioning, managing, and automating AWS infrastructure using Infrastructure as Code (IaC) best practices.

The repository documents daily practical tasks, real-world infrastructure scenarios, troubleshooting exercises, and key learnings as I progress through Terraform.

## Project Overview

- **Cloud Provider:** Amazon Web Services (AWS)
- **Infrastructure as Code:** Terraform
- **Version Control:** Git and GitHub
- **Approach:** Hands-on labs, infrastructure provisioning, lifecycle management, modularization, and troubleshooting

## Project Tracker

| Project | Description | Status |
|---|---|---|
| [Project 01](./project-01/README.md) | AWS Infrastructure Provisioning & Drift Detection | ✅ Completed |
| [Project 02](./project-02/README.md) | Terraform — AWS VPC, EC2, and Load Balancer | ✅ Completed |
| [Project 03](./project-03/README.md) | Terraform Modules, Multiple Workspaces, EC2 and RDS | ✅ Completed |

## Project 01 — AWS Infrastructure Provisioning & Drift Detection

**Status:** ✅ Completed

Provisioned AWS infrastructure using Terraform and explored lifecycle management and configuration drift.

**Key highlights:**

- Created an AWS VPC with two subnets.
- Provisioned an EC2 instance in each subnet.
- Practiced Terraform configuration, planning, and resource management.
- Explored `prevent_destroy` and `ignore_changes` lifecycle rules.
- Simulated a configuration change through the AWS Management Console and investigated Terraform drift detection.
- Organized Terraform configuration and documentation in GitHub.

**[View Project 01 documentation →](./project-01/README.md)**

## Project 02 — Terraform: AWS VPC, EC2, and Load Balancer

**Status:** ✅ Completed

Provisioned AWS infrastructure using Terraform, focusing on networking, compute resources, and load balancing.

**[View Project 02 documentation →](./project-02/README.md)**

## Project 03 — Terraform Modules with Multiple Workspaces

**Status:** ✅ Completed

Designed and provisioned reusable AWS infrastructure using Terraform modules and workspaces to manage separate DEV and QA environments.

**Key highlights:**

- Created a shared AWS networking foundation with VPC, public and private subnets, Internet Gateway, route tables, and security groups.
- Developed reusable Terraform modules for EC2 and Amazon RDS.
- Provisioned separate DEV and QA environments using Terraform workspaces.
- Configured environment-specific EC2 instance types.
- Deployed PostgreSQL RDS instances in private subnets.
- Used `terraform_remote_state` to share networking outputs between separate Terraform configurations.
- Implemented input variables, local values, outputs, and environment-specific resource tagging.
- Practiced Terraform initialization, validation, planning, applying, workspace management, and resource destruction.
- Applied Git version control and `.gitignore` practices to protect Terraform state and sensitive configuration files.

**[View Project 03 documentation →](./project-03/README.md)**

## Repository Structure

```text
Terraform-Project-RS/
│
├── .gitignore
├── README.md
│
├── project-01/
│   ├── README.md
│   ├── Task-01.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── .terraform.lock.hcl
│   └── .gitignore
│
├── project-02/
│   └── README.md
│
└── project-03/
    ├── README.md
    ├── .gitignore
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    │
    ├── foundation/
    │   ├── networking.tf
    │   ├── variables.tf
    │   ├── outputs.tf
    │   └── providers.tf
    │
    └── modules/
        ├── ec2/
        │   ├── main.tf
        │   ├── variables.tf
        │   └── outputs.tf
        │
        └── rds/
            ├── main.tf
            ├── variables.tf
            └── outputs.tf
```

*Future project directories will be added as the learning series progresses.*

## Learning Roadmap

The repository progressively covers:

- Terraform fundamentals and AWS resource provisioning
- Variables, outputs, locals, and data sources
- Terraform state management and remote backends
- Modules, workspaces, and reusable infrastructure
- Lifecycle management and drift detection
- AWS networking, EC2, RDS, and security groups
- Terraform security and IAM best practices
- CI/CD automation for infrastructure deployments
- Troubleshooting and production-oriented scenarios

## Goals

- Strengthen practical Terraform and AWS skills.
- Develop reusable and maintainable infrastructure code.
- Apply version control and secure repository practices.
- Build a portfolio of hands-on cloud infrastructure projects.
- Document technical decisions, troubleshooting, and lessons learned.

## Repository

**GitHub:** [Terraform-Project-RS](https://github.com/MoinRazvi/Terraform-Project-RS)

---

*Learning Terraform one project at a time — building practical skills in AWS infrastructure automation and Infrastructure as Code.*