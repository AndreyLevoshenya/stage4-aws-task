resource "aws_security_group" "ec2_sg" {
  vpc_id      = var.vpc_id
  description = "Allow ssh and http to instance"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }
  ingress {
    description = "HTTP access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPs access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2 Security Group"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name   = "name"
    values = var.ami_name_filter
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.public_subnets[0].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name = var.key_name # for ssh access

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_s3_full_access_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd awscli
              systemctl start httpd
              systemctl enable httpd

              mkdir -p /var/www/html
              aws s3 cp s3://andrey-levoshenya-terraform-website/ /var/www/html/ --recursive

              chown -R apache:apache /var/www/html
              chmod -R 755 /var/www/html

              EOF

  tags = {
    Name = "Terraform-EC2"
  }
}

resource "aws_iam_instance_profile" "ec2_s3_full_access_profile" {
  name = "ec2-s3-full-access-profile"
  role = var.iam_ec2_role
}