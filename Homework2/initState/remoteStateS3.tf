provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

# create an S3 bucket to store the state file in
resource "aws_s3_bucket" "lesson3hw-terraform-state-storage-s3" {
    bucket = "lesson3hw-terraform-remote-state-storage-s3"
    region = "us-east-1"
    
    versioning {
      enabled = true
    }
 
    lifecycle {
      prevent_destroy = true
    }
 
    tags = {
      Name = "lesson3hw- S3 Remote Terraform State Store"
    }      
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = "${aws_s3_bucket.lesson3hw-terraform-state-storage-s3.id}"

  block_public_acls   = true
  block_public_policy = false
}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "lesson3hw-dynamodb-terraform-state-lock" {
  name = "lesson3hw-terraform-state-lock-dynamo"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags = {
    Name = "lesson3hw- DynamoDB Terraform State Lock Table"
  }
}

