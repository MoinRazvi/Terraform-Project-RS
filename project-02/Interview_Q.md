
### Level 1: Basic Questions

#### AWS Fundamentals

1. What is Amazon VPC, and why did you create a custom VPC for this project?
2. What is a subnet, and how does it differ from a VPC?
3. What is the difference between a public subnet and a private subnet?
4. What is an Internet Gateway, and why is it required?
5. What is a route table, and how does the route `0.0.0.0/0` work?
6. What is Amazon EC2, and why did you use it in this project?
7. What is an Application Load Balancer?
8. What is a target group in AWS?
9. What is the purpose of an ALB listener?
10. What is a security group, and how is it different from a network ACL?

#### Terraform Fundamentals

11. What is Infrastructure as Code (IaC)?
12. Why did you choose Terraform for this project?
13. What are the `provider`, `resource`, `data`, and `output` blocks?
14. What is the purpose of `terraform init`?
15. What is the difference between `terraform plan` and `terraform apply`?
16. What is Terraform state, and why is it important?
17. What is the purpose of `terraform validate`?
18. What is the difference between `terraform.tfvars` and `variables.tf`?
19. What does `terraform output` do?
20. What is the purpose of `.terraform.lock.hcl`?

### Level 2: Medium Questions

#### AWS Networking and Load Balancing

1. Why did you deploy the two EC2 instances across different Availability Zones?
2. How do the VPC, subnets, route table, and Internet Gateway work together?
3. Why did you configure the ALB and EC2 instances with separate security groups?
4. Why should the EC2 security group allow HTTP traffic from the ALB security group instead of from the entire internet?
5. How does an ALB distribute traffic across registered targets?
6. What happens when one target becomes unhealthy?
7. What is the difference between an ALB and a Network Load Balancer?
8. What is the purpose of a target group's health check?
9. Why might an EC2 instance have a public IP but still be unreachable?
10. How would you configure HTTPS for this application?

#### Terraform Configuration and Lifecycle

11. Explain the purpose of `lifecycle { prevent_destroy = true }`.
12. What is `lifecycle { ignore_changes = [...] }`, and when should it be used?
13. What happens when you change the `key_name` of an existing EC2 instance?
14. Why might Terraform replace a resource instead of updating it in place?
15. How do implicit dependencies work in Terraform?
16. What is the difference between `count` and `for_each`?
17. How would you reuse the same infrastructure configuration across dev, staging, and production?
18. What is Terraform drift, and how would you detect it?
19. How would you prevent accidental infrastructure destruction?
20. Why should Terraform state files and private keys not be committed to GitHub?

### Level 3: Scenario-Based Questions

#### Scenario 1: ALB DNS Is Not Working

**Question:** You deployed the VPC, EC2 instances, and ALB successfully, but the application is not opening through the ALB DNS name. How would you troubleshoot it?

Consider:

- ALB state and listener configuration.
- Target group health status.
- ALB and EC2 security group rules.
- Nginx service status and application port.
- Subnet routing and Internet Gateway configuration.

#### Scenario 2: Targets Are Unhealthy

**Question:** Both EC2 instances are running, but the ALB target group marks them unhealthy. What would you check first, and how would you fix the issue?

#### Scenario 3: SSH Access Fails

**Question:** An EC2 instance is running, but SSH returns `Permission denied (publickey)`. How would you identify whether the issue is the key pair, username, file permissions, or instance configuration?

#### Scenario 4: Terraform Wants to Replace EC2 Instances

**Question:** You add `key_name = "Rahman-key"` to an existing EC2 resource. Terraform proposes replacing both EC2 instances and recreating target group attachments. Why does this happen, and what precautions would you take before applying the plan?

#### Scenario 5: Preventing VPC Deletion

**Question:** A teammate runs `terraform destroy`, but Terraform refuses to destroy the VPC because `prevent_destroy = true` is configured. Explain why this happens and how you would handle the request safely.

#### Scenario 6: Manual Tag Changes in AWS

**Question:** Someone changes the `Environment` tag of Server A directly in the AWS Console. The resource uses `ignore_changes = [tags["Environment"]]`. What should you expect during the next Terraform plan, and what are the trade-offs?

#### Scenario 7: One Availability Zone Fails

**Question:** Server A becomes unavailable while Server B continues running. How should the ALB behave, and what would you verify to ensure users can still access the application?

#### Scenario 8: Terraform State Is Lost

**Question:** Your local Terraform state file is accidentally deleted after the infrastructure has been created. How would you recover management of the existing resources without unnecessarily recreating them?

#### Scenario 9: Production Security Review

**Question:** A security audit identifies that both EC2 instances are in public subnets and have public IP addresses. How would you redesign the architecture to improve security while keeping the application publicly accessible through the ALB?

#### Scenario 10: Terraform Plan Shows Unexpected Destruction

**Question:** A routine code change produces a plan that destroys several resources and recreates them. What steps would you take before approving the plan?

#### Scenario 11: Application Returns HTTP 502

**Question:** The ALB is active and its DNS resolves, but users receive HTTP 502 responses. How would you investigate the problem from the ALB to the EC2 application?

#### Scenario 12: Infrastructure Changes Outside Terraform

**Question:** A teammate manually modifies a route table in the AWS Console. How would you detect the drift, assess its impact, and bring the infrastructure back to the intended configuration?

### Level 4: Senior DevOps Deep-Dive Questions

1. How would you make this infrastructure production-ready, highly available, and cost-efficient?
2. How would you replace fixed EC2 instances with an Auto Scaling Group while retaining the ALB?
3. How would you migrate Terraform state from a local file to an S3 backend with appropriate locking and access controls?
4. How would you implement a GitHub Actions pipeline for Terraform validation, planning, approval, and deployment?
5. How would you design least-privilege IAM permissions for the Terraform deployment pipeline?
6. How would you roll back an infrastructure change that caused a production outage?
7. How would you implement centralized logging, monitoring, alarms, and alerting for the ALB and EC2 instances?
8. How would you manage Terraform lifecycle rules without hiding important infrastructure drift?
9. How would you prevent concurrent Terraform applies from interfering with one another?
10. How would you design secure remote administration without exposing SSH to the public internet?

### Recommended Practical Exercises

- Explain the architecture without referring to the README.
- Trace an HTTP request from the browser to Nginx on an EC2 instance.
- Diagnose an unhealthy ALB target.
- Explain a Terraform plan involving resource replacement.
- Demonstrate `prevent_destroy` and `ignore_changes`.
- Explain how to recover from Terraform state loss.
- Propose a production-ready architecture with private EC2 subnets and HTTPS.
- Explain the project's security groups and network paths.

### Interview Answer Framework

For scenario-based questions, structure answers using these steps:

1. **Identify:** Describe the symptoms and scope of the problem.
2. **Investigate:** Explain the AWS or Terraform commands and configuration you would inspect.
3. **Resolve:** Describe the corrective action and why it addresses the root cause.
4. **Validate:** Explain how you would confirm recovery.
5. **Prevent:** Identify monitoring, automation, or design improvements to avoid recurrence.

Example commands to discuss:

```
terraform plan
terraform state list
terraform show
aws elbv2 describe-target-health --target-group-arn <TARGET_GROUP_ARN>
aws ec2 describe-security-groups
aws ec2 describe-route-tables
ssh -i "<KEY_PATH>" ubuntu@<EC2_PUBLIC_IP>
```

**Important:** Replace placeholders with actual values. Run diagnostic commands before making changes, and review Terraform plans carefully before applying infrastructure modifications.

## How to prepare for senior DevOps interviews

For your project walkthrough, prioritize these five topics:

1. Architecture: Explain how requests flow from the internet through the ALB to Nginx on the EC2 instances.
2. Networking: Explain CIDR blocks, public routing, security groups, and Availability Zones.
3. Terraform lifecycle: Explain why changing `key_name` triggers EC2 replacement and how `prevent_destroy` affects destruction.
4. Troubleshooting: Demonstrate a systematic approach to unhealthy targets, SSH failures, and HTTP 502 errors.
5. Production improvements: Discuss private subnets, HTTPS, Auto Scaling, remote state, monitoring, and GitHub Actions.

The most effective preparation is to answer each question aloud using your actual project configuration, commands, problems encountered, and verified fixes.