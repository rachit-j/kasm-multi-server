output "agent_server_ips" {
  value = [for instance in aws_instance.agent_servers : instance.public_ip]
}

output "db_server_ip" {
  value = aws_instance.db_server.public_ip
}

output "guac_server_ip" {
  value = aws_instance.guac_server.public_ip
}

output "web_server_ip" {
  value = aws_eip.web_server_eip.public_ip
}

output "key_name" {
  value = aws_key_pair.deployer.key_name
}
