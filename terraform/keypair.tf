resource "aws_key_pair" "ci-Jenkins-key" {
  key_name   = var.private_key
  public_key = file(var.public_key)
}