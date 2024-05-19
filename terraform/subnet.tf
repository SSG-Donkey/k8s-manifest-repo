##########1.PUBLIc Subnet #################
resource "aws_subnet" "public" {
  count      = length(var.public_subnet)
  vpc_id     = aws_vpc.project_vpc.id 
  cidr_block = element(var.public_subnet, count.index)
  availability_zone = element(var.azs, count.index)
    tags = {
    Name = "project_Public-Subnet_0${count.index + 1}"
    "kubernetes.io/role/elb" = "1"
  }
  map_public_ip_on_launch = true
}

################## 2. Private Subnet ####################
resource "aws_subnet" "app" {
  count      = length(var.app_subnet)
  vpc_id     = aws_vpc.project_vpc.id 
  cidr_block = element(var.app_subnet, count.index)
  availability_zone = element(var.azs, count.index)
    tags = {
    Name = "project_App-Subnet-0${count.index + 1}"
    "kubernetes.io/role/internal-elb" = "1"
  }
}
