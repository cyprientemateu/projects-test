terraform {
  backend "s3" {
    bucket         = "cyprienbucket"
    key            = "demo-project5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}