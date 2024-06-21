

#Create Images Bucket
resource "aws_s3_bucket" "cf_testbucket1" {
  bucket = var.cf_testbucket1
  acl    = "private"

  lifecycle_rule {
    id      = "MoveToGlacierMemes"
    enabled = true
    prefix = "Memes/"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  tags = {
    Name = "Images S3 Bucket"
   
  }
}
#Create Logs Bucket
resource "aws_s3_bucket" "cf_testbucket2" {
  bucket = var.cf_testbucket2
  acl    = "private"

  lifecycle_rule {
    id      = "MoveToGlacierActive"
    enabled = true
    prefix = "Active/"

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  lifecycle_rule {
    id      = "DeleteInactive"
    enabled = true
    prefix = "Inactive/"
    expiration {
      days = 90
    }
  }

  tags = {
    Name = "Logs S3 Bucket"
    
  }
}