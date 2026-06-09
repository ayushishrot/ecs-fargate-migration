terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

locals {
  name = "orders-prod"
  tags = {
    Project     = "ecs-fargate-migration"
    Environment = "production"
    ManagedBy   = "terraform"
    Owner       = "ayushi"
  }
}

resource "aws_ecr_repository" "orders" {
  name                 = "orders-prod"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.tags
}

resource "aws_secretsmanager_secret" "db_url" {
  name = "${local.name}/DATABASE_URL"
  tags = local.tags
}

module "network" {
  source             = "../../modules/network"
  name               = local.name
  cidr_block         = "10.40.0.0/16"
  azs                = ["${var.region}a", "${var.region}b", "${var.region}c"]
  single_nat_gateway = false # HA: one NAT per AZ
  tags               = local.tags
}

module "alb_waf" {
  source            = "../../modules/alb-waf"
  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  certificate_arn   = var.certificate_arn
  container_port    = 8080
  health_check_path = "/healthz"
  tags              = local.tags
}

module "ecs_service" {
  source                     = "../../modules/ecs-service"
  name                       = local.name
  vpc_id                     = module.network.vpc_id
  private_subnet_ids         = module.network.private_subnet_ids
  alb_security_group_id      = module.alb_waf.alb_security_group_id
  target_group_arn           = module.alb_waf.target_group_arn
  alb_request_resource_label = var.alb_request_resource_label
  image                      = var.image
  release                    = var.release
  desired_count              = 3
  min_count                  = 3
  max_count                  = 20
  task_cpu                   = 1024
  task_memory                = 2048
  cpu_target_value           = 55
  requests_per_target        = 800
  log_retention_days         = 90
  secret_arns                = [aws_secretsmanager_secret.db_url.arn]
  secrets = [
    { name = "DATABASE_URL", value_from = aws_secretsmanager_secret.db_url.arn },
  ]
  tags = local.tags
}
