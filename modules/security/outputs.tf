output "public_sg_id" {
  value = aws_security_group.public_sg.id
}

output "private_sg_db_id" {
  value = aws_security_group.private_sg_db.id
}
