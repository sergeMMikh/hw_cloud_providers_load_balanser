#cloud-config
package_update: true
package_upgrade: true
packages:
  - apache2

write_files:
  - path: /var/www/html/index.html
    content: |
      <html><body><h1>Welcome to SMM Home Work Web Server</h1>
      <p>Here is my image:</p>
      <img src='${s3_image_url}' alt='S3 Image'/>
      </body></html>
  - path: /var/www/html/debug.txt
    content: |
      S3 Image URL: ${s3_image_url}

runcmd:
  - systemctl start apache2
  - systemctl enable apache2
