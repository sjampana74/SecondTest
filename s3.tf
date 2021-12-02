resource "aws_s3_bucket" "gtestbucketa" {
  bucket = "gtestbucketa"
  acl = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"
     expiration {
      days = 90
    }
  }
}

resource "aws_s3_bucket" "gtestbucketb" {
  bucket = "gtestbucketb"
  acl = "private"
  force_destroy = true
  versioning {
    enabled = true
  }
  lifecycle_rule {
    id      = "log"
    enabled = true

    prefix = "log/"
     expiration {
      days = 90
    }
  }
}