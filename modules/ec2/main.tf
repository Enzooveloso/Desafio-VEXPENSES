resource "aws_instance" "debian_ec2" {
  ami             = "ami-12345678" # Substituir pelo ID correto
  instance_type   = var.instance_type
  subnet_id       = var.subnet_id
  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = [var.security_group_id]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get upgrade -y
              apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Servidor Nginx instalado com sucesso!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name        = "${var.environment}-ec2"
    Environment = var.environment
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key"
  public_key = var.ssh_public_key
}
