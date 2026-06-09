terraform {
  backend "s3" {
    bucket         = "ayushi-tfstate-ecs"
    key            = "ecs-fargate-migration/production/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ayushi-tf-locks"
    encrypt        = true
  }
}
