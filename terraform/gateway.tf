#### create Internet GateWay
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "Project-Donkey"
  }
}

#################################### NAT ####################################
# 1. Create Elastic IP for NAT
resource "aws_eip" "project_nat_eip" {
  domain   = "vpc"
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "Project-Donkey-EIP"
  }
}

# 2. Create NAT Gateway
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.project_nat_eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "Project-Donkey-NGW"
  }

  depends_on = [aws_internet_gateway.igw]
}
