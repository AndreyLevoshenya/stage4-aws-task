resource "aws_security_group" "postgres_sg" {
  description = "Security group for postgres instance to allow port 5432 from bastion"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [var.bastion_sg_id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name = "postgres-subnet-group"
  tags = {
    Name = "${local.project_name}-Postgres-Subnet-Group"
  }
  subnet_ids = [for subnet in var.private_subnets : subnet.id]
}

resource "aws_db_instance" "postgres" {
  allocated_storage = 10
  db_name           = "mjc-stage4-aws"
  engine            = "postgres"
  engine_version    = "17.5"
  instance_class    = "db.t3.micro"
  username          = "admin"
  password          = var.db_password
  

  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  db_subnet_group_name = aws_db_subnet_group.postgres_subnet_group.name

  tags = {
    Name = "${local.project_name}-Postgres-mjc-stage4-aws"
  }
}
