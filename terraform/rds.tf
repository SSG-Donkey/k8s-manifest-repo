# DB 서브넷 그룹 생성
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id 

  tags = {
    Name        = "DB Subnet Group"
    Environment = "production"
  }
}

# RDS 인스턴스 업데이트
resource "aws_db_instance" "donkey_rds" {
  identifier             = "donkey-rds"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mariadb"
  engine_version         = "10.5"
  instance_class         = "db.m6gd.large"
  name                   = "project"
  username               = var.db_user_name
  password               = var.db_user_pass
  publicly_accessible    = false
  multi_az               = true
  skip_final_snapshot    = true

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name

  tags = {
    Name = "Donkey-RDS"
    Environment = "production"
  }
}
