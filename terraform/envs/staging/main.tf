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
  name = "orders-staging"
  tags = {
    Project     = "ecs-fargate-migration"
    Environment = "staging"
    ManagedBy   = "terraform"
    Owner       = "ayushi"
  }
}

# Image registry for the migrated workload.
resource "aws_ecr_repository" "orders" {
  name                 = "orders"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = local.tags
}

# Example app secret stored in Secrets Manager, injected into the task at start.
resource "aws_secretsmanager_secret" "db_url" {
  name = "${local.name}/DATABASE_URL"
  tags = local.tags
}

module "network" {
  source             = "../../modules/network"
  name               = local.name
  cidr_block         = "10.30.0.0/16"
  azs                = ["${var.region}a", "${var.region}b"]
  single_nat_gateway = true # cost-optimized for non-prod
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
  desired_count              = 2
  min_count                  = 2
  max_count                  = 6
  task_cpu                   = 512
  task_memory                = 1024
  secret_arns                = [aws_secretsmanager_secret.db_url.arn]
  secrets = [
    { name = "DATABASE_URL", value_from = aws_secretsmanager_secret.db_url.arn },
  ]
  tags = local.tags
}
