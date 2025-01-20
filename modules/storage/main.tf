resource "aws_s3_bucket" "web_images" {
  bucket = "hw-${var.Owner}_january_2025-store-bucket"

  tags = {
    Name        = "ImagesBucket"
    Environment = "Production"
  }

}

resource "aws_s3_bucket_acl" "web_images_acl" {
  bucket = aws_s3_bucket.web_images.id
  acl    = "public-read"
}

resource "aws_s3_object" "image" {
  bucket = aws_s3_bucket.web_images.id
  key    = "cafe.jpg"
  source = "images/cafe.jpg"

  acl = "public-read"
}



