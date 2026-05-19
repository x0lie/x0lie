data "cloudflare_ip_ranges" "cloudflare" {}

resource "aws_s3_bucket" "site" {
  bucket = "x0lie.com"
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document { suffix = "index.html" }
  error_document { key = "error.html" }
}

resource "aws_s3_bucket_policy" "site" {
  bucket     = aws_s3_bucket.site.id
  depends_on = [aws_s3_bucket_public_access_block.site]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
      Condition = {
        IpAddress = {
          "aws:SourceIp" = concat(
            data.cloudflare_ip_ranges.cloudflare.ipv4_cidrs,
            data.cloudflare_ip_ranges.cloudflare.ipv6_cidrs
          )
        }
      }
    }]
  })
}
