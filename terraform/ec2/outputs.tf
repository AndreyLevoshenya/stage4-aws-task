output "ec2" {
  description = "EC2 Information"
  value = {
    id         = aws_instance.web.id
    public_ip  = aws_instance.web.public_ip
    public_dns = aws_instance.web.public_dns
  }
}