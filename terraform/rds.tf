resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = tolist([for s in aws_subnet.app : s.id])

  tags = {
    Name        = "App DB Subnet Group"
    Environment = "production"
  }
}

resource "aws_db_instance" "donkey_rds" {
  identifier             = "donkey-rds"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.5"
  instance_class         = "db.m6gd.large"
  name                   = "project"
  username               = "nana"
  password               = "nana1234"
  publicly_accessible    = true
  multi_az               = true
  skip_final_snapshot    = true

  vpc_security_group_ids = [aws_security_group.private_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.app_db_subnet_group.name

  tags = {
    Name = "Donkey-RDS"
    Environment = "production"
  }
}

# 옵셔널: RDS 인스턴스를 위한 보안 그룹이 필요한 경우
resource "aws_security_group" "rds_sg" {
  name        = "RDS-Security-Group"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.project_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.private_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Security Group"
  }
}
