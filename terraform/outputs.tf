output "server_ip_public" {
  value = module.my_server_public.public_ip
}

output "ssm_command_public" {
  value = "aws ssm start-session --target ${module.my_server_public.id}"
}

output "server_ip_private" {
  value = {
    for name, server in module.my_server_private :
    name => server.private_ip
  }
}

output "ssm_command_private" {
  value = {
    for name, server in module.my_server_private :
    name => "aws ssm start-session --target ${server.id}"
  }
}