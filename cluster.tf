module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.eks_cluster_name
  cluster_version = "1.18"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  #   manage_aws_auth = true
  enable_irsa = true

  eks_managed_node_group_defaults = [
    {
      instance_type        = "t3a.medium"
      asg_max_size         = 2
      asg_desired_capacity = 2
      root_volume_type     = "gp2"
      subnets              = module.vpc.private_subnets
    }
  ]
}
