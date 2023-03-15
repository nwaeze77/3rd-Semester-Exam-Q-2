resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "development"
  }
}

# Subnets have to be allowed to automatically map public IP addresses for worker nodes
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnet1_cidr_block
  availability_zone       = var.subnet1
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "subnet1"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my-vpc.id
  cidr_block              = var.subnet2_cidr_block
  availability_zone       = var.subnet2
  map_public_ip_on_launch = true

  tags = {
    Name                                        = "subnet2"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "kubernetes.io/role/elb"                    = "1"
  }
}

resource "aws_internet_gateway" "my-gw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-gw"
  }
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.my-gw.id
  }


  tags = {
    Name = "my-rt"
  }
}

resource "aws_route_table_association" "asso1" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_route_table_association" "asso2" {
  subnet_id      = aws_subnet.subnet1.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_security_group" "allow-traffic" {
  name        = "allow_tls"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.my-vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-web"
  }
}
