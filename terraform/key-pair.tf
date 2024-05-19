######### create Key-Pair ##################
resource "aws_key_pair" "project_key" {
    key_name   = "donkey-keypair"
    public_key = file("./donkey-keypair.pub")
    tags = {
        Name = "donkey-keypair"
    }
}
