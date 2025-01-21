resource "aws_s3_bucket" "web_images" {
  bucket = "hw-smmikh-january-2025-store-bucket"

  tags = {
    Name = "MyWebImagesBucket"
  }
}

resource "aws_s3_bucket_public_access_block" "web_images_block" {
  bucket = aws_s3_bucket.web_images.id

  block_public_acls       = false  
  block_public_policy     = false  
  ignore_public_acls      = false  
  restrict_public_buckets = false  
}


resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.web_images.id
  key    = "cafe.jpg"
  source = "images/cafe.jpg"

  etag = filemd5("images/cafe.jpg")
}

resource "aws_s3_bucket_policy" "web_images_policy" {
  bucket = aws_s3_bucket.web_images.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.web_images.arn}/*"
      }
    ]
  })
}