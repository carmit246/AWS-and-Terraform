resource "aws_s3_bucket" "lesson3hw-nginx-logs-s3-web0" {
    bucket = "lesson3hw-nginx-logs-s3-web0"
    region = "us-east-1"
    
    versioning {
      enabled = true
    }
 
    tags = {
      Name = "lesson3hw-nginx-logs-s3-web0"
    }      
}

resource "aws_s3_bucket_public_access_block" "lesson3hw-nginx-logs-s3-web0" {
  bucket = "${aws_s3_bucket.lesson3hw-nginx-logs-s3-web0.id}"

  block_public_acls   = true
  block_public_policy = false
}

resource "aws_s3_bucket" "lesson3hw-nginx-logs-s3-web1" {
    bucket = "lesson3hw-nginx-logs-s3-web1"
    region = "us-east-1"
    
    versioning {
      enabled = true
    }
 
    tags = {
      Name = "lesson3hw-nginx-logs-s3-web1"
    }      
}

resource "aws_s3_bucket_public_access_block" "lesson3hw-nginx-logs-s3-web1" {
  bucket = "${aws_s3_bucket.lesson3hw-nginx-logs-s3-web1.id}"

  block_public_acls   = true
  block_public_policy = false
}