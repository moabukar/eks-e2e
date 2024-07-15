
module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 1.0"

  zones = {
    (var.domain_name) = {
    }
  }
}
