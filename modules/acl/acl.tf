resource "aws_network_acl" "acl_publica" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "acl-public"
  }
}

resource "aws_network_acl" "acl_privada" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = var.vpc_cidr_block
    from_port  = 8080
    to_port    = 8080
  }

  egress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "acl-private"
  }
}

resource "aws_network_acl_association" "acl_association_public" {
  subnet_id      = var.public_subnet_id
  network_acl_id = aws_network_acl.acl_publica.id
}

resource "aws_network_acl_association" "acl_association_private" {
  subnet_id      = var.private_subnet_id
  network_acl_id = aws_network_acl.acl_privada.id
}
