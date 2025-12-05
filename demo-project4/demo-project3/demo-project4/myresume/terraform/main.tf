provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "resume_server" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 22.04 LTS (update if needed)
  instance_type = "t2.micro"
  key_name      = "terraform"

  security_groups = [aws_security_group.resume_sg.name]

  tags = {
    Name = "ResumeServer"
  }
}

resource "aws_security_group" "resume_sg" {
  name        = "resume-sg"
  description = "Allow HTTP, HTTPS, SSH"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
