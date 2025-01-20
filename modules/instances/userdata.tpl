#!/bin/bash
sudo apt update -y && sudo apt-get upgrade -y && sudo apt install -y mc tmux htop net-tools git 
sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
sudo echo "<html><body><h1>Welcome to My Web Server</h1><p>Here is an image:</p><img src='https://${aws_s3_bucket.web_images.bucket}.s3.amazonaws.com/web-image.jpg' alt='S3 Image'/></body></html>" > /var/www/html/index.html
