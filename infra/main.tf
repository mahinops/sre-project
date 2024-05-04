resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-tf-test-bucket300896"
  tags = {
    Environment = "test"
  }
}

resource "aws_s3_bucket_policy" "origin" {
  depends_on = [
    aws_cloudfront_distribution.s3_bucket
  ]
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.origin.json
}

data "aws_iam_policy_document" "origin" {
  depends_on = [
    aws_cloudfront_distribution.s3_bucket,
    aws_s3_bucket.s3_bucket
  ]
statement {
    sid    = "3"
    effect = "Allow"
    actions = [
      "s3:GetObject"
    ]
    principals {
      identifiers = ["cloudfront.amazonaws.com"]
      type        = "Service"
    }
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"

      values = [
        aws_cloudfront_distribution.s3_bucket.arn
      ]
    }
  }
}

resource "aws_s3_bucket_versioning" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_cloudfront_distribution" "s3_bucket" {
  depends_on = [
    aws_s3_bucket.s3_bucket,
    aws_cloudfront_origin_access_control.s3_bucket
  ]

  origin {
    domain_name              = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.s3_bucket.id
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_bucket.id
  }

  enabled             = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.s3_bucket.id
    viewer_protocol_policy = "https-only"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_control" "s3_bucket" {
  name                              = "Security_Pillar100_CF_S3_OAC"
  description                       = "OAC setup for security pillar 100"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}



output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.s3_bucket.domain_name}"
}