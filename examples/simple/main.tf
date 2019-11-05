module "aws_nlb" {
  source         = "../../"
  name           = var.nlb_name
  environment    = var.environment
  logs_s3_bucket = module.nlb_logs.aws_logs_bucket
  nlb_eip_ids    = aws_eip.nlb[*].id
  nlb_subnet_ids = module.vpc.public_subnets
  nlb_vpc_id     = module.vpc.vpc_id
}

module "nlb_logs" {
  source          = "trussworks/logs/aws"
  version         = "~> 4"
  s3_bucket_name  = var.logs_bucket
  region          = var.region
  nlb_logs_prefix = "nlb/${var.nlb_name}-${var.environment}"
}

module "vpc" {
  source             = "terraform-aws-modules/vpc/aws"
  version            = "~> 2"
  cidr               = "10.0.0.0/16"
  azs                = var.vpc_azs
  private_subnets    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway = true
}

resource "aws_eip" "nlb" {
  count = 3
  vpc   = true
}