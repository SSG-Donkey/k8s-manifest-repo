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

