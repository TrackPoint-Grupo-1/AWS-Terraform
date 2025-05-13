resource "aws_instance" "public_instance_web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name

  provisioner "file" {
    source      = var.provision_script
    destination = "/home/ubuntu/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/setup.sh",
      "/home/ubuntu/setup.sh"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }

  tags = {
    Name = "public-instance"
  }
}
