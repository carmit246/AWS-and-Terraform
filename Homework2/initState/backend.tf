terraform {
  backend "s3" {
    bucket = "lesson3hw-terraform-remote-state-storage-s3"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "lesson3hw-terraform-state-lock-dynamo"
  }
}