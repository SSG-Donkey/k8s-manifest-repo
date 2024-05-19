resource "aws_s3_bucket" "my_bucket" {
  bucket = "terraform-bucket-unique"  # 유니크한 버킷 이름
  # acl    = "private"                # 접근 권한 설정

  tags = {
    Name        = "terraform-bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "my_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.my_bucket_ownership]

  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"
}