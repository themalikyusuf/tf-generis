locals {
  name = "aws-environment"
  common_tags = {
    Name = "aws"
    Environment = "staging"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = var.vpc_cidr

  azs             = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1], data.aws_availability_zones.available.names[2]]
  private_subnets = [cidrsubnet(var.vpc_cidr, 4, 0), cidrsubnet(var.vpc_cidr, 4, 1), cidrsubnet(var.vpc_cidr, 4, 2)]
  public_subnets  = [cidrsubnet(var.vpc_cidr, 4, 3), cidrsubnet(var.vpc_cidr, 4, 4), cidrsubnet(var.vpc_cidr, 4, 5)]

  enable_nat_gateway = true

  tags = local.common_tags
}

module "db" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "~> 2.0"

  name                            = local.name

  engine                          = "aurora-mysql"
  engine_version                  = "5.7.12"

  vpc_id                          = module.vpc.vpc_id
  subnets                         = module.vpc.private_subnets

  replica_count                   = 1
  allowed_cidr_blocks             = [var.vpc_cidr]
  instance_type                   = "db.t2.medium"
  storage_encrypted               = true
  apply_immediately               = true
  monitoring_interval             = 10

  db_parameter_group_name         = aws_db_parameter_group.db_param_group.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db_cluster_param_group.name

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = local.common_tags
}

resource "aws_db_parameter_group" "db_param_group" {
  name   = local.name
  family = "aurora-mysql5.7"
}

resource "aws_rds_cluster_parameter_group" "db_cluster_param_group" {
  name        = local.name
  family      = "aurora-mysql5.7"
  description = "RDS default cluster parameter group"
}

