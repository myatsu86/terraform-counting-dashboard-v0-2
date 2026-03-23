# resource "aws_instance" "dashboard" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.counting_dashboard.key_name
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.dashboard-subnet.id
#   vpc_security_group_ids      = [aws_security_group.sg-dashboard.id]

#   user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
#     counting_private_ip = aws_instance.counting.private_ip
#   })
#   user_data_replace_on_change = true

#   tags = {
#     Name = "dashboard-instance"
#   }
# }

# resource "aws_instance" "counting" {
#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.instance_type
#   key_name                    = aws_key_pair.counting_dashboard.key_name
#   associate_public_ip_address = false
#   subnet_id                   = aws_subnet.counting-subnet.id
#   vpc_security_group_ids      = [aws_security_group.sg-counting.id]

#   user_data                   = file("${path.module}/scripts/counting-service.sh")
#   user_data_replace_on_change = true

#   tags = {
#     Name = "counting-instance"
#   }
# }

module "counting_ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.counting_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.counting_dashboard.key_name
  subnet_id                   = module.counting_dashboard_vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [ module.counting_sg.security_group_id ]

  user_data                   = file("${path.module}/scripts/counting-service.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "counting-instance"
  }
}

module "dashboard_ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = var.dashboard_name
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.counting_dashboard.key_name
  subnet_id                   = module.counting_dashboard_vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [module.dashboard_sg.security_group_id]
  user_data = templatefile("${path.module}/scripts/dashboard-service.sh", {
    counting_private_ip = module.counting_ec2_instance.private_ip
  })
  user_data_replace_on_change = true

  tags = {
    Name = "dashboard-instance"
  }
}