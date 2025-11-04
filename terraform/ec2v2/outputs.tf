output "bastion_host" {
  description = "Bastion Information"
  value = {
    id         = aws_instance.bastion_host.id
    public_ip  = aws_instance.bastion_host.public_ip
    public_dns = aws_instance.bastion_host.public_dns

    private_ip  = aws_instance.bastion_host.private_ip
    private_dns = aws_instance.bastion_host.private_dns
  }
}

output "bastion_sg" {
  description = "Bastion Security Group"
  value = {
    id   = aws_security_group.bastion_sg.id
    arn  = aws_security_group.bastion_sg.arn
    name = aws_security_group.bastion_sg.name
  }
}