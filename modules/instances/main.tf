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

resource "aws_instance" "public_vm" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.vm_public_instance_type

  key_name = var.key_name

  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true

  tags = {
    Name     = " public-${count.index + 1}"
    Owner    = var.Owner
    Project  = var.Project
    Platform = var.Platform
  }

  vpc_security_group_ids = [
    var.security_group_id,
  ]
}

resource "aws_instance" "private_vm" {
  count         = 1
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.vm_public_instance_type

  key_name = var.key_name

  subnet_id = var.private_subnet_id

  tags = {
    Name     = " private-${count.index + 1}"
    Owner    = var.Owner
    Project  = var.Project
    Platform = var.Platform
  }

  vpc_security_group_ids = [
    var.security_group_id,
  ]

}
