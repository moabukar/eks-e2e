output "route53_zone_id" {
  value = local.route53_zone_id
}

output "cert_manager_irsa_role_arn" {
  value = module.cert_manager_irsa.this_iam_role_arn
}
