resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "mongodb_backup" {
  bucket        = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  force_destroy = true

  tags = {
    Name        = "mongodb-backups"
    Environment = "prod"
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.mongodb_backup.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read_list" {
  bucket = aws_s3_bucket.mongodb_backup.id
  depends_on = [
    aws_s3_bucket_public_access_block.public_access
  ]
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          aws_s3_bucket.mongodb_backup.arn,
          "${aws_s3_bucket.mongodb_backup.arn}/*"
        ]
      }
    ]
  })
}