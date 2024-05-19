resource "aws_ecr_repository" "donkey-board2" {
  name = "donkey-board2"
}

output "ecr_repository_url_donkey-board2" {
  value = aws_ecr_repository.donkey-board2.repository_url
}


resource "aws_ecr_repository" "donkey-frontend2" {
  name = "donkey-frontend2"
}

output "ecr_repository_url_donkey-frontend2" {
  value = aws_ecr_repository.donkey-frontend2.repository_url
}


resource "aws_ecr_repository" "donkey-payment2" {
  name = "donkey-payment2"
}

output "ecr_repository_url_donkey-payment2" {
  value = aws_ecr_repository.donkey-payment2.repository_url
}


resource "aws_ecr_repository" "donkey-user2" {
  name = "donkey-user2"
}

output "ecr_repository_url_donkey-user2" {
  value = aws_ecr_repository.donkey-user2.repository_url
}

