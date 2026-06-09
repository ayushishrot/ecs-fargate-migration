# Remote state in S3 with DynamoDB state locking.
# Bootstrap the bucket/table once, then `terraform init`.
terraform {
  backend "s3" {
    bucket         = "ayushi-tfstate-ecs"
    key            = "ecs-fargate-migration/staging/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "ayushi-tf-locks"
    encrypt        = true
  }
}
