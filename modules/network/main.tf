resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "MyVPC"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "MyInternetGateway"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.10.1.0/24"

  map_public_ip_on_launch = true

  availability_zone = "eu-central-1a"

  tags = {
    Name = "PublicSubnet"
  }
}
resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.10.0/24"  # Изменённый диапазон
  availability_zone = "eu-central-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetA"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.11.0/24"  # Новый диапазон
  availability_zone = "eu-central-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnetB"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.20.0/24"  # Изменённый диапазон
  availability_zone = "eu-central-1a"

  tags = {
    Name = "PrivateSubnetA"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.21.0/24"  # Новый диапазон
  availability_zone = "eu-central-1b"

  tags = {
    Name = "PrivateSubnetB"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "PublicRouteTable"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}


# Elastic IP для NAT Gateway в зоне public_a
resource "aws_eip" "nat_a" {
  domain = "vpc"

  tags = {
    Name = "NAT-Gateway-A-EIP"
  }
}

# Elastic IP для NAT Gateway в зоне public_b
resource "aws_eip" "nat_b" {
  domain = "vpc"

  tags = {
    Name = "NAT-Gateway-B-EIP"
  }
}


# NAT-шлюз для public_a (eu-central-1a)
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name = "NAT-Gateway-A"
  }

  depends_on = [aws_internet_gateway.igw]
}

# NAT-шлюз для public_b (eu-central-1b)
resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b.id
  subnet_id     = aws_subnet.public_b.id

  tags = {
    Name = "NAT-Gateway-B"
  }

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id  # Привязка к NAT в eu-central-1a
  }

  tags = {
    Name = "PrivateRouteTableA"
  }
}

# Таблица маршрутизации для private_b (eu-central-1b)
resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id  # Привязка к NAT в eu-central-1b
  }

  tags = {
    Name = "PrivateRouteTableB"
  }
}

# Ассоциация private_a с таблицей маршрутов private_a
resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# Ассоциация private_b с таблицей маршрутов private_b
resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_security_group" "default" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MySecurityGroup"
  }
}

