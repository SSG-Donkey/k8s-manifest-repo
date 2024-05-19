########crete Bastion Instance on Public Subnet ################
resource "aws_instance" "project_bastion" {
  ami               = data.aws_ami.amazon_linux_2023.id
  instance_type     = "t2.large"
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name          = aws_key_pair.project_key.key_name
  subnet_id         = aws_subnet.public[0].id
  associate_public_ip_address = true

  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("./donkey-keypair")}"
    host = self.public_ip
  }

  provisioner "file" {
    source = "./donkey-keypair"
    destination = "/home/ec2-user/donkey-keypair"
  }

  tags = {
    Name = "Project-Bastion-Instance"
  }
}
# Null resource for bastion provisioning
resource "null_resource" "bastion_provisioning" {
  triggers = {
    bastion_instance_id = aws_instance.project_bastion.id
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ec2-user/donkey-keypair",
    ]
    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = "${file("./donkey-keypair")}"
      host        = aws_instance.project_bastion.public_ip
    }
  }
}

################## Create WAS Instance on Private Subnet ################
resource "aws_instance" "project_was" {
  ami               = data.aws_ami.amazon_linux_2023.id
  instance_type     = "t2.large"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  key_name          = aws_key_pair.project_key.key_name
  subnet_id         = aws_subnet.app[0].id
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.eks_instance_profile.name
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = "${file("./donkey-keypair")}"
    host = aws_instance.project_bastion.public_ip
  }

  tags = {
    Name = "Project-app-Instance"
  }
}

