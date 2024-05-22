############create Security Group for Bastion Instances ##################
resource "aws_security_group" "bastion_sg" {
    name        = "Project-Bastion-SG"
    description = "Allow Traffic to Baistion"
    vpc_id      = aws_vpc.project_vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        "Name" = "Project-Bastion-SG"
    }
}


resource "aws_security_group" "private_sg" {
  name        = "private-security-group"
  description = "Security group for private"

  vpc_id = aws_vpc.project_vpc.id

  // 인바운드 규칙
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] 
  }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        security_groups = [aws_security_group.bastion_sg.id]
    }
  // 아웃바운드 규칙
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

# DB 인스턴스용 보안 그룹 생성
resource "aws_security_group" "db_sg" {
    name        = "Project-DB-SG"
    description = "Security group for Database instances"
    vpc_id      = aws_vpc.project_vpc.id

    # 인바운드 규칙: DB 접근을 위한 포트 3306을 개방하고, 내부 서브넷에서만 접근 허용
    ingress {
        from_port   = 3306
        to_port     = 3306
        protocol    = "tcp"
        security_groups = [aws_security_group.private_sg.id]  # 프라이빗 서브넷 보안 그룹에서만 접근 허용
    }

    # 아웃바운드 규칙: 모든 트래픽 허용
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        "Name" = "Project-DB-SG"
    }
}

