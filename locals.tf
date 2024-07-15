locals {
  eks_cluster_name = "${var.name}-eks"
  route53_zone_id  = module.zones.this_route53_zone_zone_id[var.domain_name]
}
