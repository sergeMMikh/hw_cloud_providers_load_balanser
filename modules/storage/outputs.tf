output "s3_image_url" {
  value       = "https://${aws_s3_bucket.web_images.bucket}.s3.amazonaws.com/${aws_s3_object.image.key}"
  description = "Public URL of the image stored in S3"
}
