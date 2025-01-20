data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "web_server_lc" {
  name          = "web-server-launch-configuration"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.vm_public_instance_type
  key_name      = var.key_name

  security_groups = [var.security_group_id]

  user_data = <<-EOF
                #!/bin/bash
                apt-get update -y
                apt-get install -y apache2
                systemctl start apache2
                systemctl enable apache2
                echo "<html><body><h1>Welcome to My Web Server</h1><p>Here is an image:</p><img src='${var.s3_image_url}' alt='S3 Image'/></body></html>" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web_asg" {
  launch_configuration = aws_launch_configuration.web_server_lc.id
  min_size             = 3
  max_size             = 3
  desired_capacity     = 3
  vpc_zone_identifier  = [var.private_subnet_id]

  health_check_grace_period = 300
  health_check_type         = "EC2"

  target_group_arns = [aws_lb_target_group.web_target_group.arn]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb" "web_alb" {
  name               = "web-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  subnets            = [var.public_subnet_id]

  enable_deletion_protection = false

  tags = {
    Name = "WebALB"
  }
}

resource "aws_lb_target_group" "web_target_group" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

