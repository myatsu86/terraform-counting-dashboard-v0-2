output "dashboard_instance_public_ip" {
  description = "Public IP of the dashboard instance"
  value       = module.dashboard_ec2_instance.public_ip
}

output "counting_instance_private_ip" {
  description = "Private IP of the counting instance"
  value       = module.counting_ec2_instance.private_ip
}