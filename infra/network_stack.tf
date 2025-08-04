# Create a VPC Stack
resource "aws_vpc" "obinna_dev_vpc" {
  cidr_block       = "10.100.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Obinna's Private Cloud"
  }
}

resource "aws_internet_gateway" "internet_igw" {
  vpc_id = aws_vpc.obinna_dev_vpc.id

  tags = {
    Name = "Obinna IGW"
  }
}

# Create subnets and automatically assign public IPs to resources launched within
resource "aws_subnet" "obinna_public_subnet_1" {
  vpc_id                  = aws_vpc.obinna_dev_vpc.id
  cidr_block              = "10.100.10.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    "Name" = "obinna_public_subnet_1"
  }
}

resource "aws_route_table" "route_table_1" {
  vpc_id = aws_vpc.obinna_dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_igw.id
  }

  tags = {
    Name = "public_rt_a"
  }
}

resource "aws_route_table_association" "subnet_rt_attached_a" {
  subnet_id      = aws_subnet.obinna_public_subnet_1.id
  route_table_id = aws_route_table.route_table_1.id
}

# Create the second subnets and its components
resource "aws_subnet" "obinna_public_subnet_2" {
  vpc_id                  = aws_vpc.obinna_dev_vpc.id
  cidr_block              = "10.100.20.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    "Name" = "obinna_public_subnet_2"
  }
}

resource "aws_route_table" "route_table_2" {
  vpc_id = aws_vpc.obinna_dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_igw.id
  }

  tags = {
    Name = "public_rt_b"
  }
}

resource "aws_route_table_association" "subnet_rt_attached_b" {
  subnet_id      = aws_subnet.obinna_public_subnet_2.id
  route_table_id = aws_route_table.route_table_2.id
}
