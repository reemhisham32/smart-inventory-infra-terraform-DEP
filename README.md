# 🏗️ Smart Inventory — AWS Infrastructure (Terraform)

Terraform code to provision a production-ready **AWS EKS** cluster for the Smart Inventory application. Infrastructure is managed as code using modular Terraform, with remote state stored in S3 and an automated Jenkins pipeline for deployments.

---

<img width="1600" height="650" alt="WhatsApp Image 2026-05-12 at 1 25 50 AM" src="https://github.com/user-attachments/assets/ddba3d8c-cd78-4b32-8dab-1273a1c8cf88" />

<img width="1600" height="883" alt="WhatsApp Image 2026-05-12 at 2 48 59 PM" src="https://github.com/user-attachments/assets/a04fad68-0763-494f-b426-d9c7a76f28af" />
<img width="1600" height="766" alt="WhatsApp Image 2026-05-12 at 1 18 08 AM" src="https://github.com/user-attachments/assets/1282486c-86f9-455f-92e5-524696a1ff2c" />


## 🗂️ Project Structure

```
smart-inventory-infra-terraform-DEP/
├── main.tf              # Root module — wires all sub-modules together
├── variables.tf         # Input variable declarations
├── outputs.tf           # Output values (cluster endpoint, etc.)
├── providers.tf         # AWS & Kubernetes provider configuration
├── backend.tf           # S3 remote state backend
├── terraform.tfvars     # Variable values
├── Jenkinsfile          # CI/CD pipeline for infrastructure
└── modules/
    ├── vpc/             # VPC, subnets, NAT gateway, routing
    ├── eks/             # EKS cluster + managed node groups
    ├── iam/             # IAM roles for EKS cluster & nodes
    └── security-groups/ # Security groups for cluster & nodes
```

---

## ☁️ Infrastructure Overview

| Resource | Details |
|----------|---------|
| **VPC** | Custom CIDR, public & private subnets across multiple AZs |
| **NAT Gateway** | Enables private subnet internet access (configurable: single or per-AZ) |
| **EKS Cluster** | Managed Kubernetes with configurable version & encryption |
| **Node Group** | Auto-scaling managed node group (min/desired/max configurable) |
| **IAM Roles** | Separate roles for cluster control plane and worker nodes |
| **Security Groups** | Dedicated SGs for cluster API and worker nodes |
| **Remote State** | S3 bucket `mynoteapp-devops`, region `eu-west-1`, encrypted with lock file |

---

## 📦 Modules

### `modules/vpc`
Provisions the network layer:
- VPC with custom CIDR
- Public and private subnets across specified availability zones
- NAT Gateway(s) for outbound traffic from private subnets
- Route tables and associations
- DNS hostnames & support enabled by default

### `modules/eks`
Provisions the Kubernetes cluster:
- EKS control plane with configurable Kubernetes version
- Managed node group with auto-scaling
- Optional secrets encryption via KMS
- Control plane logging (API, audit, authenticator, scheduler, controller manager)
- Nodes placed in private subnets

### `modules/iam`
Provisions IAM roles and policies:
- `eks_cluster_role_arn` — for the EKS control plane
- `eks_node_role_arn` — for worker nodes (used in `aws-auth` ConfigMap)
- Support for additional IAM users/roles to access the cluster

### `modules/security-groups`
Provisions security groups:
- Cluster security group (API server access)
- Node security group (inter-node + node-to-control-plane communication)
- Configurable allowed SSH IPs for nodes

---

## 🔧 Configuration

Key variables in `terraform.tfvars`:

| Variable | Description |
|----------|-------------|
| `project_name` | Project identifier used in resource naming |
| `environment` | Deployment environment (`dev`, `staging`, `prod`) |
| `aws_region` | AWS region |
| `vpc_cidr` | VPC CIDR block |
| `availability_zones` | List of AZs for subnet distribution |
| `public_subnet_cidrs` | CIDRs for public subnets |
| `private_subnet_cidrs` | CIDRs for private subnets |
| `cluster_version` | Kubernetes version |
| `node_group_desired_size` | Desired number of worker nodes |
| `node_group_min_size` | Minimum worker nodes |
| `node_group_max_size` | Maximum worker nodes |
| `node_instance_types` | EC2 instance types for nodes |
| `node_disk_size` | Disk size (GB) per node |
| `enable_cluster_encryption` | Enable KMS encryption for secrets |
| `single_nat_gateway` | Use one NAT GW (cost-saving) vs per-AZ |

---

## 🚀 Getting Started

### Prerequisites
- Terraform >= 1.0
- AWS CLI configured with appropriate permissions
- Access to the S3 state bucket (`mynoteapp-devops`)

### Deploy Manually

```bash
# 1. Initialize Terraform (downloads providers & configures S3 backend)
terraform init

# 2. Check formatting
terraform fmt -check -recursive

# 3. Validate configuration
terraform validate

# 4. Preview changes
terraform plan -out=tfplan

# 5. Apply (creates all AWS resources)
terraform apply tfplan
```

### Destroy Infrastructure

```bash
terraform destroy
```

> ⚠️ This will terminate the EKS cluster and all associated resources.

---

## ⚙️ Jenkins CI/CD Pipeline

The `Jenkinsfile` automates infrastructure changes through these stages:

| Stage | Description |
|-------|-------------|
| **Checkout Code** | Pull latest code from GitHub |
| **Terraform Format Check** | Enforce consistent code formatting |
| **Terraform Init** | Initialize backend and download providers |
| **Terraform Validate** | Syntax and configuration validation |
| **Terraform Plan** | Generate and save execution plan |
| **Terraform Apply** | Apply plan — **only on `master` branch**, requires manual approval |

### Manual Approval Gate
The `Apply` stage includes an `input` step requiring human confirmation before any infrastructure changes are applied to AWS. This prevents accidental changes from automated runs.

### Environment Variables
```
AWS_DEFAULT_REGION = us-east-1
TF_IN_AUTOMATION   = true
```

---

## 🔐 Remote State

State is stored remotely to enable team collaboration and prevent conflicts:

```hcl
backend "s3" {
  bucket       = "mynoteapp-devops"
  key          = "eks/terraform.tfstate"
  region       = "eu-west-1"
  encrypt      = true
  use_lockfile = true
}
```

---

## 🔗 Related Repository

Application code, Dockerfile, and Kubernetes manifests:  
👉 [smart-inventory-devopss-project-DEPI](https://github.com/reemhisham32/smart-inventory-devopss-project-DEPI)

