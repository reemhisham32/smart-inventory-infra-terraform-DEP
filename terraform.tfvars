# ===========================================================================
# PROJECT CONFIGURATION
# ============================================================================
project_name = "my-eks-project"
environment  = "dev"
aws_region   = "us-east-1"

# ============================================================================
# VPC CONFIGURATION
# ============================================================================
vpc_cidr             = "10.0.0.0/16"
availability_zones   = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
enable_nat_gateway   = true
single_nat_gateway   = true
enable_dns_hostnames = true
enable_dns_support   = true

# ============================================================================
# EKS CONFIGURATION
# ============================================================================
cluster_version           = "1.34"
node_group_desired_size   = 1
node_group_min_size       = 1
node_group_max_size       = 2
node_instance_types       = ["t3.medium"]
node_disk_size            = 20
enable_cluster_encryption = true
cluster_log_types         = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

# ============================================================================
# SECURITY CONFIGURATION
# ============================================================================
allowed_ssh_ips = ["41.238.157.251/32"]

# ============================================================================
# IAM ACCESS CONFIGURATION - Grant Kubernetes Access
# ============================================================================

additional_iam_users = [
  {
    userarn  = "arn:aws:iam::707136105613:user/Marwa_Atef102"
    username = "Marwa_Atef102"
    groups   = ["system:masters"]
  }
]

additional_iam_roles = [
  {
    rolearn  = "arn:aws:iam::707136105613:role/JenkinsRole"
    username = "jenkins"
    groups   = ["system:masters"]
  }
]

# ============================================================================
# TAGS
# ============================================================================
tags = {
  Project     = "EKS-Infrastructure"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "DevOps-Team"
}