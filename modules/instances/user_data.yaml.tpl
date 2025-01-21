#cloud-config
package_update: true
package_upgrade: true
packages:
  - apache2

runcmd:
  - systemctl start apache2
  - systemctl enable apache2
  - echo "<html><body><h1>Welcome to SMM Home Work Web Server</h1><p>Here is may image:</p><img src='${s3_image_url}' alt='S3 Image'/></body></html>" > /var/www/html/index.html
  - echo "S3 Image URL: ${s3_image_url}" > /var/www/html/debug.txt