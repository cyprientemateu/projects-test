variable "public_key" {}

resource "aws_key_pair" "deployer" {
  key_name   = "tcc-ec2-key"
  public_key = var.public_key
}

resource "aws_instance" "web" {
  ami           = "ami-0c02fb55956c7d316" # example for Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer.key_name

  tags = {
    Name = "TCC-Web"
  }
}