resource "aws_eks_cluster" "my_cluster" {
  name     = "terraform-eks-donkey"
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = aws_subnet.app[*].id  # 프라이빗 서브넷 ID를 사용
    endpoint_public_access = true # 퍼블릭 엔드포인트 설정 추가
    endpoint_private_access = true # 프라이빗 엔드포인트 설정 추가
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKSVPCResourceController,
  ]
}

# IAM OIDC Provider
resource "aws_iam_openid_connect_provider" "cluster" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
}

# OIDC Provider에서 사용하는 인증서 데이터 소스
data "tls_certificate" "cluster" {
  url = aws_eks_cluster.my_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role-terraform"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_AmazonEKSVPCResourceController" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}
resource "null_resource" "update_kubeconfig" {
  depends_on = [aws_eks_cluster.my_cluster]

  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --region ap-northeast-2 --name terraform-eks-donkey"
  }
}
