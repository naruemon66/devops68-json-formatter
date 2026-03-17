provider "aws" {
  region = var.aws_region
}

# Key Pair
resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0400"
}

# Security Group
resource "aws_security_group" "app_sg" {
  name_prefix = "app_sg"

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

# EC2
resource "aws_instance" "app" {
  ami                    = "ami-0e5b9e1afa5e50e27"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              exec > /var/log/user-data.log 2>&1

              apt update -y
              apt install -y curl git

              curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
              apt install -y nodejs

              cd /home/ubuntu
              git clone https://github.com/YOUR_USERNAME/YOUR_FORKED_REPO.git app

              cd app
              npm init -y
              npm install express

              nohup node index.js > app.log 2>&1 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "json-formatter-app"
  }
}
