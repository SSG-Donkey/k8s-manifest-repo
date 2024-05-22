###### create Routing Table #################
# 1. Public Routing Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Project-Public-RT"
  }
}

# 2. Private Routing Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "Project-Private-RT"
  }
}

################# Associate RoutingTable ###################
# 1. Bastion Subnet
resource "aws_route_table_association" "publi_subnet_asso" {
  count         = length(var.public_subnet)
  subnet_id     = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

# 2. WAS Subnet
resource "aws_route_table_association" "was_subnet_asso" {
  count         = length(var.app_subnet)
  subnet_id     = element(aws_subnet.app[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

# 3. DB Subnet
resource "aws_route_table_association" "db_subnet_asso" {
  count          = length(var.db_subnet)
  subnet_id      = element(aws_subnet.db_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
