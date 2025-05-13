output "public_ip" {
  value = aws_instance.public_instance_web_server.public_ip
}

output "instance_id" {
  value = aws_instance.public_instance_web_server.id
}
