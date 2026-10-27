# # Project 02: AWS Infrastructure Provisioning with Terraform | VPC, EC2, ALB, Subnets & Networking
---
## Overview

This project demonstrates how to provision and manage highly available AWS web infrastructure using **Terraform (Infrastructure as Code)**. It creates a custom VPC, public subnets across multiple Availability Zones, EC2 web servers, and an Application Load Balancer (ALB) to distribute incoming HTTP traffic.

The project also demonstrates Terraform lifecycle management, security group configuration, SSH access, and infrastructure troubleshooting.

## Architecture

```text
                         Internet Users
                               |
                               | HTTP :80
                               v
                    +----------------------+
                    | Application Load     |
                    | Balancer (ALB)       |
                    +----------------------+
                         /           \
                        /             \
                       v               v
             +----------------+  +----------------+
             | Availability   |  | Availability   |
             | Zone A         |  | Zone B         |
             |                |  |                |
             | Subnet-A       |  | Subnet-B       |
             | 10.20.1.0/24   |  | 10.20.2.0/24   |
             |                |  |                |
             | EC2 Server A   |  | EC2 Server B   |
             | Nginx           |  | Nginx          |
             +----------------+  +----------------+
                        \             /
                         \           /
                    +--------------------+
                    | Target Group       |
                    | HTTP :80           |
                    +--------------------+

               AWS VPC: 10.20.0.0/16
                         |
               +--------------------+
               | Internet Gateway   |
               +--------------------+
                         |
                    Internet Route
                    0.0.0.0/0
```

> **Note:** The diagram illustrates the logical architecture. The ALB uses its target group to route requests to the registered EC2 instances. Both public subnets are associated with a route table that provides internet routing through the Internet Gateway.

## Technology Stack

| Technology | Purpose |
|---|---|
| AWS VPC | Isolated virtual network |
| Public Subnets | Host web servers across Availability Zones |
| Internet Gateway | Provide internet connectivity |
| Route Tables | Control network routing |
| Amazon EC2 | Run web server instances |
| Nginx | Serve web pages |
| Application Load Balancer | Distribute incoming HTTP traffic |
| Target Group | Register and route traffic to EC2 instances |
| Security Groups | Control inbound network access |
| Terraform | Provision and manage infrastructure |
| Git and GitHub | Version control and project management |

## Infrastructure Components

### 1. Networking

- Created a custom VPC with CIDR `10.20.0.0/16`.
- Created two public subnets:
  - Subnet-A: `10.20.1.0/24`
  - Subnet-B: `10.20.2.0/24`
- Deployed the subnets in separate Availability Zones.
- Created an Internet Gateway and attached it to the VPC.
- Configured a public route table with a default route to the Internet Gateway.
- Associated both public subnets with the route table.
- Enabled public IP assignment on instance launch.

### 2. EC2 Web Servers

- Provisioned two EC2 instances using Terraform.
- Used an Ubuntu 24.04 AMI data source.
- Installed Nginx using EC2 user data.
- Configured server-specific web pages to help identify which backend serves a request.
- Configured the `Rahman-key` EC2 key pair for SSH access.

### 3. Application Load Balancer

- Created an Application Load Balancer.
- Configured an ALB security group to allow HTTP traffic on port `80`.
- Created a target group using HTTP on port `80`.
- Registered both EC2 instances with the target group.
- Created an HTTP listener on port `80`.
- Configured the ALB to distribute requests between the registered web servers.

### 4. Security Groups

The project uses separate security groups for the load balancer and web servers.

| Security Group | Port | Source | Purpose |
|---|---:|---|---|
| ALB security group | 80 | Internet (`0.0.0.0/0`) | Accept HTTP requests |
| Web server security group | 80 | ALB security group | Permit web traffic from the ALB |
| Web server security group | 22 | Trusted public IP `/32` | Permit restricted SSH administration |

**Security consideration:** SSH should not be exposed to the entire internet. Restrict it to a trusted IP address or use AWS Systems Manager Session Manager where appropriate.

## Terraform Lifecycle Management

This project explores Terraform lifecycle rules that influence how resources are managed.

### `prevent_destroy`

Applied to the VPC resource to prevent Terraform from destroying it while the lifecycle rule remains in the configuration.

```hcl
lifecycle {
  prevent_destroy = true
}
```

**Purpose:** Protect critical infrastructure against accidental destruction.

### `ignore_changes`

Applied to the environment tag of Server A.

```hcl
lifecycle {
  ignore_changes = [
    tags["Environment"]
  ]
}
```

**Purpose:** Tell Terraform to ignore subsequent changes to the specified tag when planning updates.

**Important:** `ignore_changes` should be used selectively. It can hide configuration drift for the attributes being ignored.

## Project Directory Structure

```text
terraform/
└── project-02/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── providers.tf
    ├── terraform.tfvars
    ├── .terraform.lock.hcl
    ├── .gitignore
    └── README.md
```

The exact files may vary depending on how the Terraform configuration is organized. Keep `.terraform.lock.hcl` under version control, and do not commit state files, private keys, or sensitive credentials.

## Deployment Guide

### Prerequisites

- An AWS account with permissions to create the required networking, EC2, and load-balancing resources.
- AWS CLI installed and configured.
- Terraform installed.
- Git installed.
- An EC2 key pair if SSH access is required.

Verify AWS credentials:

```bash
aws sts get-caller-identity
```

Verify Terraform and AWS CLI versions:

```bash
terraform version
aws --version
```

### Step 1: Navigate to the project

```bash
cd project-02
```

### Step 2: Initialize Terraform

```bash
terraform init
```

Downloads the required provider plugins and initializes the working directory.

### Step 3: Validate the configuration

```bash
terraform fmt -recursive
terraform validate
```

- `terraform fmt` formats Terraform configuration files.
- `terraform validate` checks the configuration for syntax and internal consistency.

### Step 4: Review the execution plan

```bash
terraform plan
```

Review the proposed resource additions, modifications, and deletions before proceeding.

### Step 5: Provision the infrastructure

```bash
terraform apply
```

Review the plan and confirm the operation when prompted. For repeatable automated workflows, use a reviewed plan file where appropriate.

### Step 6: Retrieve the application URL

```bash
terraform output
terraform output alb_dns_name
terraform output application_url
```

Open the resulting ALB DNS name or application URL in a browser.

The output names above assume they are defined in `outputs.tf`. Use the actual names from your configuration if they differ.

### Step 7: Test the application

```bash
curl -I "$(terraform output -raw application_url)"
```

Refresh the application several times to observe the server-specific responses. Load balancing behavior depends on target health, listener configuration, and the ALB's routing behavior.

### Step 8: Connect to an EC2 instance using SSH

From Git Bash on Windows, use the actual public IP address of the instance:

```bash
chmod 400 "/c/Users/DELL/Downloads/Rahman-key.pem"

ssh -i "/c/Users/DELL/Downloads/Rahman-key.pem" \
  ubuntu@<EC2_PUBLIC_IP>
```

Replace `<EC2_PUBLIC_IP>` with the current instance IP.

Do not upload or commit the private key file to GitHub.

## Troubleshooting and Lessons Learned

### 1. SSH connection failed

**Issue:** SSH access failed because the instance did not have the expected key pair or the security group did not allow SSH from the client IP.

**Resolution:**
- Verified the EC2 key pair.
- Configured `key_name = "Rahman-key"` in Terraform.
- Added a restricted SSH ingress rule for the trusted client IP.
- Used the correct local private-key path and file permissions.
- Verified connectivity from VS Code.

**Learning:** SSH requires a matching key pair, a valid username, network reachability, and appropriate security group rules.

### 2. EC2 instances required replacement

**Issue:** Adding a key pair to existing EC2 instances resulted in a Terraform plan showing instance replacement and changes to target group attachments.

**Resolution:** Reviewed the plan before applying it and accounted for the dependent target group attachments.

**Learning:** Some EC2 attributes, including the key pair name, require resource replacement. Always inspect the plan before applying changes.

### 3. Application connectivity

**Issue:** A working EC2 instance alone does not guarantee that the application is reachable through the ALB.

**Validation checklist:**
- Confirm the ALB is active.
- Confirm the listener forwards requests to the correct target group.
- Confirm target group health checks are passing.
- Confirm the web server security group allows HTTP from the ALB security group.
- Confirm Nginx is running on the backend instances.
- Confirm the subnets and routing are configured correctly.

### 4. Git staging and project isolation

**Issue:** Changes from `project-01/` appeared while preparing to commit `project-02/`.

**Resolution:** Stage only the Project 2 directory rather than all repository changes.

```bash
git add project-02/
git status
git diff --cached --stat
```

**Learning:** Explicit staging prevents unrelated project changes from entering a commit.

## Useful Terraform Commands

| Command | Purpose |
|---|---|
| `terraform init` | Initialize the working directory |
| `terraform fmt` | Format Terraform files |
| `terraform validate` | Validate configuration |
| `terraform plan` | Preview infrastructure changes |
| `terraform apply` | Apply planned changes |
| `terraform output` | Display Terraform outputs |
| `terraform state list` | List resources tracked in state |
| `terraform show` | Display the current state or a saved plan |
| `terraform plan -destroy` | Preview resource destruction |
| `terraform destroy` | Destroy managed infrastructure, subject to lifecycle rules |

Use `terraform destroy` only when you intend to remove the resources. The `prevent_destroy` rule can block destruction of the protected VPC until the configuration is changed.

## Git Workflow

Run these commands from the repository root:

```bash
git status
git add project-02/
git diff --cached --stat
git commit -m "Add Terraform Project 2: VPC, EC2 and ALB"
git push -u origin project-02
```

Before committing, verify that only intended Project 2 files are staged and that no secrets, `.pem` files, Terraform state, or plan artifacts are included.

## Learning Outcomes

By completing this project, I practiced:

- Provisioning AWS infrastructure through Terraform.
- Designing a VPC with subnets across Availability Zones.
- Configuring public routing and internet access.
- Deploying EC2 instances with user-data automation.
- Configuring an Application Load Balancer and target group.
- Implementing security group rules for application and administration traffic.
- Understanding Terraform lifecycle management with `prevent_destroy` and `ignore_changes`.
- Reviewing resource replacement and dependency changes through Terraform plans.
- Troubleshooting SSH and application connectivity.
- Managing project changes safely with Git.

## Future Enhancements

- Move Terraform state to a secured S3 backend with state locking.
- Separate development, staging, and production environments.
- Use private subnets for web servers and a controlled outbound access design.
- Add an Auto Scaling Group instead of managing fixed EC2 instances.
- Configure HTTPS with an ACM certificate.
- Add CloudWatch monitoring, alarms, and ALB access logs.
- Integrate Terraform validation and plan checks into GitHub Actions.
- Use AWS Systems Manager Session Manager to reduce direct SSH exposure.

## Conclusion

This project demonstrates a practical Infrastructure as Code workflow for provisioning AWS networking, compute, and load-balancing components. It also highlights the importance of reviewing Terraform plans, protecting critical resources with lifecycle rules, securing administrative access, and validating connectivity across infrastructure layers.

**Key takeaway:** Reliable infrastructure automation requires more than provisioning resources—it requires controlled changes, secure access, clear validation, and operational troubleshooting.
