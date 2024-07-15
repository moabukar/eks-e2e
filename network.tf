module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.0.0/23", "10.0.2.0/23", "10.0.4.0/23"]
  public_subnets  = ["10.0.100.0/23", "10.0.102.0/23", "10.0.104.0/23"]

  enable_dns_hostnames = true

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_cluster_name}" : "shared"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.name}-eks" : "shared"
  }
}
