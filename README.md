# Counting & Dashboard Infrastructure
 
A Terraform project that provisions a two-tier application architecture on AWS, consisting of a **Dashboard (frontend)** and a **Counting (backend)** service, connected via a shared VPC with public and private subnets.
 
---
 
## Architecture Overview
 
```
                        Internet
                           │
                    ┌──────▼──────┐
                    │     IGW     │
                    └──────┬──────┘
                           │
              ┌────────────▼─────────────┐
              │         Public Subnet     │
              │   ┌───────────────────┐   │
              │   │   Dashboard EC2   │   │
              │   │  (dashboard-sg)   │   │
              │   └────────┬──────────┘   │
              └────────────┼──────────────┘
                           │ Port 9000 (SG rule)
              ┌────────────▼─────────────┐
              │         Private Subnet    │
              │   ┌───────────────────┐   │
              │   │   Counting EC2    │   │
              │   │  (counting-sg)    │   │
              │   └───────────────────┘   │
              └──────────────────────────┘
                        VPC
```
 
- **Dashboard EC2** lives in the **public subnet** with a public IP
- **Counting EC2** lives in the **private subnet** with no public IP
- Counting service is only reachable from the Dashboard SG on port 9000
- Both instances share the same VPC, created by the VPC module
 
---
 
## Project Structure
 
```
.
├── vpc.tf              # VPC, subnets, IGW, NAT Gateway
├── sg.tf               # Security Groups for dashboard and counting
├── instance.tf         # EC2 instances for dashboard and counting
├── variables.tf        # Variable declarations
├── terraform.tfvars    # Static input values
├── outputs.tf          # Output values
└── scripts/
    ├── dashboard-service.sh   # Dashboard EC2 user data
    └── counting-service.sh    # Counting EC2 user data
```
 
---
 
## Modules Used
 
| Module | Source | Purpose |
|---|---|---|
| `counting_dashboard_vpc` | `terraform-aws-modules/vpc/aws` | VPC, subnets, IGW, NAT |
| `dashboard_sg` | `terraform-aws-modules/security-group/aws` | SG for Dashboard EC2 |
| `counting_sg` | `terraform-aws-modules/security-group/aws` | SG for Counting EC2 |
| `dashboard_ec2_instance` | `terraform-aws-modules/ec2-instance/aws` | Dashboard EC2 instance |
| `counting_ec2_instance` | `terraform-aws-modules/ec2-instance/aws` | Counting EC2 instance |
 
---