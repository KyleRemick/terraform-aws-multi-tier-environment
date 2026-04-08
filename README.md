# terraform-aws-multi-tier-environment

Terraform configuration for a small multi-tier AWS layout: public subnets for an internet-facing Application Load Balancer and NAT, private subnets for Auto Scaling Group instances, and security groups that restrict application traffic to the load balancer path only.

## Architecture

Internet clients reach an **Application Load Balancer** in **two public subnets** (two Availability Zones). The ALB forwards HTTP to **EC2 instances** in **two private subnets**. Those instances are not reachable directly from the internet at the security-group layer: they accept traffic only from the ALB security group on the application port. Outbound traffic from private subnets uses a **NAT Gateway** in a public subnet (typical pattern for package updates and AWS API calls without public instance IPs).

```text
                    Internet
                       |
                       v
              +----------------+
              |  ALB (public)  |
              +--------+-------+
                       |
         +-------------+-------------+
         |                           |
   +-----v-----+               +-----v-----+
   | public    |               | public    |
   | subnet A  |               | subnet B  |
   | (ALB,NAT) |               | (ALB)     |
   +-----------+               +-----------+
         |
         | (private route via NAT)
         v
   +-----------+               +-----------+
   | private   |               | private   |
   | subnet A  |               | subnet B  |
   | (ASG/EC2) |               | (ASG/EC2) |
   +-----------+               +-----------+
```

### What this provisions

| Area | Resources |
|------|-----------|
| **Networking** | VPC, two public and two private subnets across two AZs, Internet Gateway, one NAT Gateway, route tables and associations |
| **Security** | ALB security group (listener port from the internet), EC2 security group (application port from ALB only) |
| **Load balancing** | Application Load Balancer, target group, HTTP listener |
| **Compute** | IAM role and instance profile (SSM-ready), launch template (Amazon Linux 2023 via SSM parameter), Auto Scaling Group registered with the target group |

Application instances install **nginx** via `user_data` so the target group health check can return HTTP `200` on the configured path.

### Why this repo exists

This project is meant to be easy to scan on GitHub: modular Terraform, a standard network topology, and security-group layering that matches how teams explain “DMZ + private tier” in interviews. It is scoped to stay readable—not every AWS service, but the ones that show up constantly in cloud and support roles.

### Skills demonstrated

- VPC design across multiple AZs (subnets, routing, NAT vs IGW paths)
- Terraform modules with clear inputs and outputs
- Application Load Balancer, target group, and listener wiring
- Security groups used as a deliberate perimeter (internet → ALB → instances only)
- Auto Scaling Group with launch template and ELB health checks
- IAM least-privilege baseline for instances (SSM Session Manager attachment) without opening SSH from the internet

## Requirements

- [Terraform](https://www.terraform.io/downloads) `>= 1.5.0`
- An AWS account and credentials configured (for example [AWS CLI](https://aws.amazon.com/cli/) `aws configure`, or environment variables such as `AWS_PROFILE`)
- Permissions to create VPC, EC2, ELB, IAM, and related resources in the chosen region

**Cost note:** NAT Gateways and load balancers are billed continuously in most cases. Tear down the stack when you are done testing (`terraform destroy`).

Commit [`.terraform.lock.hcl`](.terraform.lock.hcl) after `terraform init` so provider versions stay reproducible for anyone cloning the repo.

## Repository layout

```text
.
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── terraform.tfvars.example
├── .terraform.lock.hcl
└── modules/
    ├── networking/
    ├── security/
    ├── alb/
    └── compute/
```

## Deploy

1. **Clone** the repository and enter the directory.

2. **Copy variables** and edit for your account:

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

   On Windows PowerShell, use the same copy command, or run `terraform plan` after copying—Terraform loads `terraform.tfvars` automatically. Avoid `terraform plan -var-file=terraform.tfvars.example` in some PowerShell setups; copying to `terraform.tfvars` is the reliable approach.

   Adjust `aws_region`, CIDRs, instance sizing, and Auto Scaling limits. Ensure `asg_desired_capacity` stays between `asg_min_size` and `asg_max_size` (enforced by variable validation).

3. **Initialize** Terraform:

   ```bash
   terraform init
   ```

4. **Format and validate** (optional but recommended before `plan`):

   ```bash
   terraform fmt -recursive
   terraform validate
   ```

5. **Review** the planned changes:

   ```bash
   terraform plan
   ```

6. **Apply**:

   ```bash
   terraform apply
   ```

7. **Verify** the deployment:

   ```bash
   terraform output
   ```

   Open `alb_dns_name` in a browser over HTTP (same port as `alb_listener_port`, default `80`). You should see the default nginx page or a successful response if you changed the app. Right after `apply`, the ALB may briefly return `502` while targets register and pass health checks—retry after a minute if needed.

8. **Destroy** when finished (recommended for non-production demos):

   ```bash
   terraform destroy
   ```

### Example outputs

Values below are illustrative; your IDs and DNS name will differ.

```text
alb_dns_name             = "multitier-dev-alb-1234567890.us-east-1.elb.amazonaws.com"
alb_arn                  = "arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/multitier-dev-alb/abc..."
autoscaling_group_name   = "multitier-dev-asg"
ec2_security_group_id      = "sg-0abc123def456789"
nat_gateway_id           = "nat-0123456789abcdef0"
public_subnet_ids        = ["subnet-aaa...", "subnet-bbb..."]
private_subnet_ids       = ["subnet-ccc...", "subnet-ddd..."]
target_group_arn         = "arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/..."
vpc_id                   = "vpc-0123456789abcdef0"
```

## Design decisions

- **Single NAT Gateway** — Reduces monthly cost for a portfolio/demo. It is a single point of failure for egress from private subnets; production designs often use one NAT per AZ or other egress patterns.
- **Target group name** — Left to Terraform to avoid naming collisions and length limits when iterating.
- **Amazon Linux 2023 AMI via SSM parameter** — Avoids hard-coding an AMI ID per region.
- **SSM (`AmazonSSMManagedInstanceCore`)** — Supports Session Manager without opening SSH from the internet, which matches the security-group story.
- **Provider `default_tags`** — Keeps `Project`, `Environment`, and `ManagedBy` consistent across supported resources.

## Possible future enhancements

- **TLS on the ALB** — ACM certificate and an HTTPS listener; redirect HTTP to HTTPS.
- **HTTPS-only ingress** — Restrict security group to `443` only once TLS is in place.
- **Observability** — CloudWatch alarms on ALB `5xx`, `TargetResponseTime`, or ASG capacity.
- **Remote state** — S3 backend and DynamoDB locking for collaboration or CI pipelines.
- **NAT per AZ** — If you need to document higher availability for egress.

## License

This repository is provided as-is for learning and portfolio use. Add a license file if you want explicit terms for reuse.
