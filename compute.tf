#######################
# AMAZON MACHINE IMAGE
#######################

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical's Ubuntu Publisher
}

#################
# EC2 INSTANCE
#################

resource "aws_instance" "web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.web_tier.id]
  user_data              = <<-EOT
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install nginx -y
    sudo systemctl enable --now nginx
    echo "Hello from $(hostname)" > /var/www/html/index.html
  EOT

  count = 2
  tags = {
    Name = "ginosko-server-${count.index + 1}"
  }
}
