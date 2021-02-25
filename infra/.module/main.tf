resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "${var.application_name}-${var.prefix}"
  force_destroy = var.force_destroy
  provider      = aws
  
  grant {
    id          = var.user_id 
    type        = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "${var.application_name}-${var.prefix}"
    enabled = true

    expiration {
      days = var.expiration_days
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_master_key_id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
