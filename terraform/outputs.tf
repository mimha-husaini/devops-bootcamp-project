output "rackula_url" {
  value = "http://${module.my_server.public_ip}:8080"
}

output "ssm_connect_command" {
  value = "aws ssm start-session --target ${module.my_server.id} --region ap-southeast-1"
}

output "instance_id" {
  value = module.my_server.id
}