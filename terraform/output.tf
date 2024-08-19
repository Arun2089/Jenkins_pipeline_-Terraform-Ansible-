output "public_instance_ip" {
  value = aws_instance.public_instance[0].public_ip
  description = "The public IP of the public instance"
}

output "private_instance_ip" {
  value = aws_instance.private_instance[0].private_ip
  description = "The private IP of the private instance"
}

