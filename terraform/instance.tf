resource "aws_instance" "private_instance" {
  count = 1
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.medium"
  subnet_id     = module.vpc.private_subnets[0]
  key_name      = "Key"
  vpc_security_group_ids = [aws_security_group.sg_instance.id]

  tags = {
    Name = "Private_Instance_${count.index + 1}"
  }
}

resource "aws_instance" "public_instance" {
  count = 1
  ami           = "ami-0ad21ae1d0696ad58"
  instance_type = "t2.medium"
  subnet_id     = module.vpc.public_subnets[count.index]
  key_name      = "Key"
  vpc_security_group_ids = [aws_security_group.sg_instance.id]
  associate_public_ip_address = true

  tags = {
    Name = "Public_Instance_${count.index + 1}"
  }
}