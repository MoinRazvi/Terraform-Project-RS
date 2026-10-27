### AWS Fundamentals

**1. What is Amazon VPC, and why did you create a custom VPC?**

**Answer:** A Virtual Private Cloud (VPC) is a logically isolated network in AWS where we define IP address ranges, subnets, routing, and network security. In this project, I created a VPC with CIDR `10.20.0.0/16` to control the network layout and deploy the web servers and load balancer within a dedicated network.

**2. What is a subnet, and how does it differ from a VPC?**

**Answer:** A VPC is the overall network boundary, while a subnet is a smaller IP address range inside that VPC. I created two subnets, `10.20.1.0/24` and `10.20.2.0/24`, to distribute the web servers across separate Availability Zones.

**3. What is the difference between a public and a private subnet?**

**Answer:** A public subnet has a route to an Internet Gateway. A private subnet does not have a direct route to an Internet Gateway for internet access. In this project, both web-server subnets are public. For production, I would generally place the EC2 instances in private subnets and expose the application through a public ALB.

**4. What is an Internet Gateway?**

**Answer:** An Internet Gateway enables communication between resources in a VPC and the internet when routing, public addressing, and security rules permit it. I attached an Internet Gateway to the VPC and configured a default route of `0.0.0.0/0` through it.

**5. What is a route table?**

**Answer:** A route table contains rules that determine where network traffic is sent. My public route table includes a default route to the Internet Gateway. Both public subnets are associated with this route table.

**6. What is Amazon EC2?**

**Answer:** Amazon EC2 provides virtual servers in AWS. I provisioned two EC2 instances using Terraform and installed Nginx through user data so each instance could serve a web page.

**7. What is an Application Load Balancer?**

**Answer:** An ALB is a Layer 7 load balancer that routes HTTP and HTTPS requests based on configured listener rules. I used it as the application's entry point to distribute incoming HTTP requests to the two registered EC2 instances.

**8. What is a target group?**

**Answer:** A target group defines the backend targets that receive traffic from a load balancer. In my project, the target group registers both EC2 instances on HTTP port 80 and checks whether they are healthy.

**9. What is an ALB listener?**

**Answer:** A listener checks for incoming connections on a configured protocol and port. My ALB has an HTTP listener on port 80 that forwards requests to the target group.

**10. What is a security group?**

**Answer:** A security group is a stateful virtual firewall attached to AWS resources such as EC2 instances and load balancers. I configured one security group for the ALB to accept HTTP traffic and another for the web servers to accept HTTP from the ALB security group. SSH is restricted to a trusted IP address.

### Terraform Fundamentals

**11. What is Infrastructure as Code (IaC)?**

**Answer:** IaC means defining and managing infrastructure through configuration files rather than creating everything manually. Terraform allows me to version-control infrastructure, review planned changes, and recreate environments consistently.

**12. Why did you use Terraform?**

**Answer:** I used Terraform because it supports declarative infrastructure definitions, dependency management, reusable configuration, and plan-based change review. It also makes the infrastructure easier to maintain in Git.

**13. Explain `provider`, `resource`, `data`, and `output` blocks.**

**Answer:**
- `provider`: Configures the infrastructure provider, such as AWS.
- `resource`: Defines infrastructure Terraform should manage.
- `data`: Reads information about existing resources or external data, such as an available Ubuntu AMI.
- `output`: Exposes useful values, such as the ALB DNS name or application URL.

**14. What does `terraform init` do?**

**Answer:** It initializes the working directory, downloads the required providers and modules, and configures the backend if one is defined.

**15. What is the difference between `terraform plan` and `terraform apply`?**

**Answer:** `terraform plan` previews the changes Terraform intends to make. `terraform apply` executes the changes. I review the plan before applying it, especially when it proposes resource replacement or destruction.

**16. What is Terraform state?**

**Answer:** Terraform state maps the configuration to the real infrastructure and records resource attributes and identifiers. Terraform uses it to determine which resources need to be created, changed, or destroyed.

**17. What does `terraform validate` do?**

**Answer:** It checks whether Terraform configuration is syntactically valid and internally consistent. It does not guarantee that AWS permissions are sufficient or that the infrastructure will deploy successfully.

**18. What is the difference between `variables.tf` and `terraform.tfvars`?**

**Answer:** `variables.tf` declares input variables and their types or defaults. `terraform.tfvars` supplies values for those variables. Keeping them separate makes configurations easier to reuse across environments.

**19. What does `terraform output` do?**

**Answer:** It displays output values defined in the configuration. In this project, outputs can expose the ALB DNS name and application URL so I can test the deployed application without manually searching the AWS Console.

**20. What is `.terraform.lock.hcl`?**

**Answer:** It records selected provider versions and checksums. Committing it helps ensure consistent provider selections across machines and CI/CD runs. It is different from the Terraform state file and should normally be committed to Git.

---

## Level 2: Medium questions

### AWS Networking and Load Balancing

**1. Why deploy the EC2 instances across different Availability Zones?**

**Answer:** Distributing instances across Availability Zones improves resilience against a failure affecting one zone. An ALB can route requests to healthy targets in the remaining available zones. However, actual resilience depends on healthy targets, subnet configuration, and sufficient capacity.

**2. Explain how the VPC, subnets, route table, and Internet Gateway work together.**

**Answer:** The VPC provides the network boundary. The subnets divide its CIDR range. The route table determines traffic paths, and the Internet Gateway provides the VPC's internet connection. In my project, both subnets use a route table whose default route points to the Internet Gateway. Public IP addressing and security group rules are also required for internet connectivity.

**3. Why use separate ALB and EC2 security groups?**

**Answer:** It separates the public entry point from the application servers. The ALB security group accepts HTTP requests from users, while the EC2 security group permits application traffic from the ALB security group. This follows least-privilege principles more closely than allowing HTTP from any source directly to the EC2 instances.

**4. Why allow HTTP from the ALB security group instead of the entire internet on EC2?**

**Answer:** The ALB is the intended entry point for application traffic. Referencing its security group restricts inbound web traffic to resources associated with that group. It reduces direct exposure of the backend servers.

**5. How does an ALB distribute traffic?**

**Answer:** The ALB receives requests through its listener and forwards them according to its rules to a target group. It selects eligible healthy targets according to ALB routing behavior. Target registration, health checks, and security group rules must all be correct.

**6. What happens if one target becomes unhealthy?**

**Answer:** The ALB stops routing new requests to the unhealthy target when health-check evaluation marks it unhealthy, and sends traffic to eligible healthy targets. If all targets are unhealthy, users may still receive errors; therefore, health checks and sufficient backend capacity are important.

**7. What is the difference between an ALB and an NLB?**

**Answer:** An ALB operates at Layer 7 and supports HTTP/HTTPS routing, host-based routing, and path-based routing. An NLB operates at Layer 4 and handles TCP, UDP, and TLS traffic with different performance and networking characteristics. I selected an ALB because this project serves an HTTP web application.

**8. Why are target-group health checks important?**

**Answer:** Health checks help the ALB determine whether a target can receive traffic. If Nginx is stopped, the health-check path is incorrect, or port 80 is blocked, a target can become unhealthy even when the EC2 instance itself is running.

**9. Why might an EC2 instance with a public IP still be unreachable?**

**Answer:** A public IP alone does not guarantee connectivity. I would verify the subnet route to the Internet Gateway, the instance's public addressing, security group rules, network ACLs, operating-system firewall, service status, and the client's network access.

**10. How would you configure HTTPS?**

**Answer:** I would request or import an appropriate certificate in AWS Certificate Manager, configure an HTTPS listener on port 443, and attach the certificate. I would allow HTTPS inbound on the ALB security group. If the backend remains HTTP, I would restrict backend port 80 to the ALB security group. I would also consider an HTTP-to-HTTPS redirect.

### Terraform Configuration and Lifecycle

**11. What does `prevent_destroy = true` do?**

**Answer:** It instructs Terraform to reject a plan that would destroy the protected resource while the lifecycle rule remains in the configuration. I used it to protect the VPC from accidental deletion. It is a safeguard, not a backup, and removing the resource block or changing the configuration still requires careful review.

**12. What does `ignore_changes` do?**

**Answer:** It tells Terraform to ignore changes to specified resource attributes during update planning. I used it for Server A's `Environment` tag. This can be useful when another process manages that attribute, but it can also conceal unwanted drift.

**13. Why can changing `key_name` replace an EC2 instance?**

**Answer:** The EC2 key pair name is a launch-time attribute that Terraform's AWS provider treats as requiring replacement. Terraform therefore proposes a new instance instead of updating the existing instance in place. Dependent target group attachments may also need replacement because the instance IDs change.

**14. Why does Terraform sometimes replace a resource instead of updating it?**

**Answer:** Some provider attributes cannot be changed in place through the underlying AWS API. When a replacement-required attribute changes, Terraform plans to destroy and recreate the resource, subject to lifecycle rules and dependencies. I inspect the plan to identify which resources and dependencies are affected.

**15. What are implicit dependencies in Terraform?**

**Answer:** Terraform infers dependencies when one resource references another resource's attributes. For example, a target group attachment referencing an EC2 instance ID depends on that instance. Terraform uses the dependency graph to determine operation order. `depends_on` is available when a dependency cannot be inferred from an expression.

**16. What is the difference between `count` and `for_each`?**

**Answer:** `count` creates indexed instances, such as `aws_instance.web[0]` and `aws_instance.web[1]`. `for_each` creates instances keyed by a map or set, such as `aws_instance.web["server-a"]`. I would use `for_each` when instances have distinct identities and stable keys.

**17. How would you support dev, staging, and production?**

**Answer:** I would separate environment-specific configuration and variables, use reusable modules, and isolate state between environments. I would also use environment-specific AWS permissions and deployment approvals. This reduces accidental changes to the wrong environment.

**18. What is Terraform drift, and how do you detect it?**

**Answer:** Drift occurs when actual infrastructure differs from the configuration or recorded state, often because someone changes resources manually. I would run `terraform plan` to identify proposed reconciliation changes and investigate before applying them.

**19. How do you prevent accidental infrastructure destruction?**

**Answer:** I use lifecycle protections for critical resources where appropriate, review plans, restrict IAM permissions, require approval for production changes, and maintain protected remote state. I also use backups or recovery strategies for critical data. Lifecycle rules alone are not a complete disaster-recovery solution.

**20. Why should state files and private keys not be committed to GitHub?**

**Answer:** State files can contain sensitive infrastructure details and potentially sensitive values. Private keys can allow unauthorized access to servers. I exclude state, plans, private keys, and `.terraform/` from Git using `.gitignore`, while retaining `.terraform.lock.hcl`. I also use secure secret storage and rotate any credential that may have been exposed.

---

## Level 3: Scenario-based questions and answers

### Scenario 1: ALB DNS is not opening

**Question:** You deployed everything successfully, but the application is not opening through the ALB DNS name. How would you troubleshoot it?

**Answer:**

I would troubleshoot from the entry point toward the backend:

1. Check that the ALB is active and has the expected DNS name.
2. Verify the listener is configured on port 80 and forwards to the correct target group.
3. Check target health and health-check failure reasons.
4. Verify the ALB security group permits inbound HTTP traffic.
5. Verify the EC2 security group permits HTTP from the ALB security group.
6. Connect to the instances and confirm Nginx is running and listening on port 80.
7. Verify subnet routing and the Internet Gateway.

Useful commands:

```bash
terraform output alb_dns_name
aws elbv2 describe-target-health \
  --target-group-arn <TARGET_GROUP_ARN>
curl -I http://<ALB_DNS_NAME>
```

I would fix the root cause and retest the application through the ALB, not only by connecting directly to an EC2 instance.

### Scenario 2: Target group reports unhealthy instances

**Question:** Both EC2 instances are running, but the ALB target group marks them unhealthy. What would you check?

**Answer:**

An EC2 instance being in the running state does not mean the web application is healthy. I would check the health-check protocol, port, and path; Nginx status; security group rules; and the target group's health reason.

On Ubuntu, I could run:

```bash
sudo systemctl status nginx
sudo ss -lntp
curl -I http://localhost
```

If the health check expects a path that returns an unsuccessful response, I would correct the path or application response. If traffic is blocked, I would fix the relevant security group rule and then confirm the targets become healthy.

### Scenario 3: SSH returns `Permission denied (publickey)`

**Question:** An EC2 instance is running, but SSH authentication fails. What would you do?

**Answer:**

I would distinguish authentication problems from network connectivity problems.

- Confirm I am connecting to the correct instance and current public IP.
- Verify the correct private key matches the EC2 key pair.
- Use the correct default username for the AMI; for Ubuntu, it is typically `ubuntu`.
- Confirm the private-key file path and file permissions.
- Confirm the instance was launched with the intended key pair.
- Check that port 22 is allowed from my current trusted public IP.

Example:

```bash
chmod 400 "/path/to/Rahman-key.pem"
ssh -i "/path/to/Rahman-key.pem" \
  ubuntu@<EC2_PUBLIC_IP>
```

If the instance was launched with the wrong key, adding a key pair to the Terraform configuration may force replacement. I would review the plan and consider a safe recovery method before replacing a running server.

### Scenario 4: Terraform proposes replacing EC2 instances

**Question:** After adding `key_name = "Rahman-key"`, Terraform proposes replacing both EC2 instances and their target group attachments. What is your response?

**Answer:**

I would first inspect the plan and confirm that the key pair change is the replacement trigger. I would identify dependent resources and assess the impact on application availability, instance data, and public IP addresses.

Before applying, I would confirm that the key pair exists, the configuration is correct, and the new instances can become healthy targets. For a production system, I would plan a rolling or blue-green migration rather than replacing all serving instances at once. I would not approve the plan until the impact and recovery strategy were understood.

### Scenario 5: `prevent_destroy` blocks VPC deletion

**Question:** A teammate runs `terraform destroy`, but Terraform refuses to delete the VPC. Why?

**Answer:**

The VPC has `lifecycle { prevent_destroy = true }`, so Terraform rejects a plan that destroys the protected resource while that rule is present. I would first confirm whether destruction is actually required, identify dependent resources, and obtain approval. If deletion is approved, I would deliberately modify the protection and review the resulting plan. I would never remove the safeguard merely to force an operation without understanding the impact.

### Scenario 6: A tag is changed manually in AWS

**Question:** Someone changes Server A's `Environment` tag in the AWS Console. The resource uses `ignore_changes` for that tag. What happens?

**Answer:**

Terraform ignores changes to the specified tag during update planning, so the tag change may not be proposed for reconciliation. This is useful if another system intentionally manages the tag, but it can also allow incorrect metadata to persist. If Terraform should be the source of truth for that tag, I would remove the ignore rule and review a plan to restore the intended value.

### Scenario 7: One Availability Zone fails

**Question:** Server A becomes unavailable while Server B remains healthy. How should the application behave?

**Answer:**

The ALB should stop routing new requests to the unhealthy target and continue routing to healthy targets. I would verify that Server B is healthy and has enough capacity, then check the target group health status, ALB metrics, and application logs. This project has two instances, but production resilience also requires capacity planning, multi-AZ design, and potentially an Auto Scaling Group.

### Scenario 8: Terraform state file is lost

**Question:** The local Terraform state file is deleted after resources have been created. How would you recover?

**Answer:**

I would avoid immediately running `terraform apply`, because Terraform may not know that the resources already exist. First, I would search for a state backup or remote state copy. If none exists, I would reconstruct state carefully by importing existing resources into the configuration, validating each resource ID and dependency, and reviewing a plan for unintended creation or destruction. For future projects, I would use a secured remote backend with recovery and access controls.

### Scenario 9: Security audit finds public EC2 instances

**Question:** Both EC2 instances have public IP addresses. How would you redesign the architecture?

**Answer:**

I would keep the ALB in public subnets and move the application instances to private subnets. The EC2 security group would accept application traffic only from the ALB security group. For outbound internet access, I would evaluate NAT Gateway or suitable VPC endpoints based on requirements. I would use Systems Manager Session Manager or another controlled administrative path instead of exposing SSH publicly. I would plan the migration to avoid application downtime.

### Scenario 10: Terraform plan shows unexpected destruction

**Question:** A small configuration change results in several resources being destroyed and recreated. What would you do?

**Answer:**

I would stop before applying and review the complete plan. I would look for replacement markers, changed resource identifiers, renamed resource addresses, provider changes, and dependency changes. I would compare the configuration with the current state and confirm whether a resource replacement is intended. If a resource was renamed, a Terraform `moved` block may be appropriate. I would apply only after understanding the proposed changes and getting any required approval.

### Scenario 11: The ALB returns HTTP 502

**Question:** The ALB is active and its DNS resolves, but users receive HTTP 502. How would you investigate?

**Answer:**

I would check target health first, then verify that the backend is listening on the expected port and protocol. I would inspect Nginx and application logs, target-group configuration, security group rules, and whether the backend closes connections unexpectedly. I would compare the ALB listener's forwarding configuration with the target group's protocol and port. After the fix, I would retest through the ALB and monitor errors.

### Scenario 12: A route table is changed manually

**Question:** A teammate modifies a route table directly in the AWS Console. How do you detect and resolve the drift?

**Answer:**

I would run `terraform plan` to identify differences between the desired configuration and actual infrastructure. I would determine whether the manual change was intentional and assess its network impact. If the Terraform configuration is authoritative, I would review the plan and apply the approved reconciliation. If the change is required, I would update the configuration first so future plans do not reverse it unexpectedly.

---

## Level 4: Senior DevOps deep-dive questions

**1. How would you make this project production-ready?**

**Answer:** I would put the ALB in public subnets and application instances in private subnets, enable HTTPS, use an Auto Scaling Group, configure monitoring and alerts, secure Terraform state remotely, and implement controlled CI/CD deployment. I would also introduce backups, least-privilege IAM, centralized logs, and a documented recovery process.

**2. How would you replace fixed EC2 instances with an Auto Scaling Group?**

**Answer:** I would create a launch template containing the AMI, instance type, IAM profile, security group, and bootstrap configuration. Then I would create an Auto Scaling Group spanning multiple private subnets and attach it to the ALB target group. I would configure health checks, minimum and maximum capacity, desired capacity, and scaling policies. I would test replacement and scaling before removing the manually managed instances.

**3. How would you migrate local Terraform state to S3?**

**Answer:** I would create a secured S3 bucket with versioning and restrictive IAM access, configure the S3 backend with the appropriate locking mechanism supported by the Terraform version, and back up the existing state. Then I would update the backend configuration and run `terraform init -migrate-state`. Finally, I would verify the migrated state and run `terraform plan` to confirm there are no unintended infrastructure changes.

**4. How would you implement Terraform in GitHub Actions?**

**Answer:** I would create a workflow that runs formatting, validation, and planning for pull requests. Production applies would require approval through protected environments. I would use GitHub Actions OIDC federation to obtain short-lived AWS credentials instead of storing long-lived access keys. I would also restrict workflow permissions and separate plan and apply permissions where appropriate.

**5. How would you implement least-privilege IAM?**

**Answer:** I would grant only the AWS actions and resources required by the Terraform configuration. I would separate provisioning permissions from runtime application permissions, avoid wildcard access where possible, and use short-lived credentials through OIDC. I would validate the permissions against actual deployment requirements and review CloudTrail activity.

**6. How would you roll back an infrastructure change that causes an outage?**

**Answer:** I would assess the impact and restore service using the safest available path. Depending on the change, that might mean reverting the configuration, deploying a known-good version, restoring the previous target group or launch template, or applying a reviewed corrective plan. I would not blindly run `terraform destroy`. I would verify service health and investigate the root cause after recovery.

**7. How would you implement monitoring and logging?**

**Answer:** I would monitor ALB request count, latency, HTTP error metrics, and healthy host counts using CloudWatch. I would configure alarms and notifications for meaningful thresholds. I would also collect EC2 and application logs, enable ALB access logging where required, and define dashboards and incident-response procedures.

**8. How would you manage lifecycle rules without hiding drift?**

**Answer:** I would apply `ignore_changes` only to attributes intentionally managed by another process and document the reason. I would avoid broad ignore rules and periodically review drift. For critical resources, I would use lifecycle protection alongside access controls, plan review, backups, and change approval.

**9. How would you prevent concurrent Terraform applies?**

**Answer:** I would use a remote backend with supported state locking, so concurrent operations on the same state cannot safely proceed at the same time. In CI/CD, I would also use workflow concurrency controls and restrict who can apply changes. I would avoid running local and pipeline applies concurrently against the same environment.

**10. How would you administer private EC2 instances securely?**

**Answer:** I would prefer AWS Systems Manager Session Manager with the appropriate instance IAM role, network connectivity, and access policies. This avoids requiring a public IP or inbound SSH access. If SSH were necessary, I would use a controlled bastion or private connectivity and tightly restricted access, with auditing and key-management practices.
