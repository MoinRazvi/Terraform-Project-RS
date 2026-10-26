# Terraform Daily Projects — AWS Infrastructure as Code

A hands-on Terraform learning repository focused on provisioning, managing, and automating AWS infrastructure using Infrastructure as Code (IaC) best practices.

The repository documents daily practical tasks, real-world infrastructure scenarios, troubleshooting exercises, and key learnings as I progress through Terraform.

## Project Overview

- **Cloud Provider:** Amazon Web Services (AWS)
- **Infrastructure as Code:** Terraform
- **Version Control:** Git and GitHub
- **Approach:** Hands-on labs, infrastructure provisioning, lifecycle management, and troubleshooting

## Project Tracker

| Project | Description | Status |
|---|---|---|
| [Project 01](./project-01/README.md) | AWS Infrastructure Provisioning & Drift Detection | ✅ Completed |
| Project 02 | Upcoming Terraform practical task | ⏳ Planned |
| Project 03 | Upcoming Terraform practical task | ⏳ Planned |

*The upcoming project descriptions will be updated as new tasks are completed.*

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

## Repository Structure

```text
Terraform-Project-RS/
├── .gitignore
├── README.md
├── project-01/
│   ├── README.md
│   ├── Task-01.md
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── .terraform.lock.hcl
│   └── .gitignore
├── project-02/
│   └── README.md
└── project-03/
    └── README.md
```

*Future project directories will be added as the learning series progresses.*

## Learning Roadmap

The repository will progressively cover:

- Terraform fundamentals and AWS resource provisioning
- Variables, outputs, locals, and data sources
- Terraform state management and remote backends
- Modules, workspaces, and reusable infrastructure
- Lifecycle management and drift detection
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
