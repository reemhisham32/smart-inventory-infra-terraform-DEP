terraform {
  backend "s3" {
    bucket       = "mynoteapp-devops"
    key          = "eks/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }
}

