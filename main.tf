# provider "aws" {
#   region = "us-east-1"
# }

# # Criando VPC
# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/23"

#   tags = {
#     Name = "main-vpc"
#   }
# }

# # Subnet pública
# resource "aws_subnet" "public" {
#   vpc_id                  = aws_vpc.main.id
#   cidr_block              = "10.0.0.0/24"
#   map_public_ip_on_launch = true
#   availability_zone       = "us-east-1a"

#   tags = {
#     Name = "public-subnet"
#   }
# }

# # Subnet privada
# resource "aws_subnet" "private" {
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"

#   tags = {
#     Name = "private-subnet"
#   }
# }

# # Internet Gateway
# resource "aws_internet_gateway" "gw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "internet-gateway"
#   }
# }

# # NAT Gateway (usado para permitir que as instâncias privadas acessem a internet)
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "nat" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.public.id

#   tags = {
#     Name = "nat-gateway"
#   }
# }

# # Roteamento público
# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.gw.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }

# # Roteamento privado
# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat.id
#   }

#   tags = {
#     Name = "private-route-table"
#   }
# }

# # Associar a tabela de rotas públicas
# resource "aws_route_table_association" "public_assoc" {
#   subnet_id      = aws_subnet.public.id
#   route_table_id = aws_route_table.public.id
# }

# # Associar a tabela de rotas privadas
# resource "aws_route_table_association" "private_assoc" {
#   subnet_id      = aws_subnet.private.id
#   route_table_id = aws_route_table.private.id
# }

# # Security Group para instâncias públicas (front-end e Nginx)
# resource "aws_security_group" "public_sg" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "public-sg"
#   }
# }


# # Security Group para o banco de dados
# resource "aws_security_group" "private_sg_db" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     security_groups = [aws_security_group.public_sg.id]
#   }

#   ingress {
#     from_port   = 3306
#     to_port     = 3306
#     protocol    = "tcp"
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "private-sg-db"
#   }
# }

# resource "aws_instance" "public_instance_web_server" {
#   ami                  = "ami-04b4f1a9cf54c11d0"
#   instance_type        = "t2.micro"
#   subnet_id            = aws_subnet.public.id
#   vpc_security_group_ids = [aws_security_group.public_sg.id]
#   key_name            = "Key-Public-Front-01"

#   provisioner "file" {
#     source      = "./scripts/setup.sh"
#     destination = "/home/ubuntu/setup.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [ 
#       "chmod +x /home/ubuntu/setup.sh",
#       "/home/ubuntu/setup.sh"
#     ]
#   }

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file("./chaves/Key-Public-Front-01.pem")
#     host        = aws_instance.public_instance_web_server.public_ip
#   }

#   tags = {
#     Name = "public-instance"
#   }

# }

# # Buckets S3
# resource "aws_s3_bucket" "raw_bucket" {
#   bucket = "my-raw-bucket-sprint2-${random_id.bucket_id.hex}"  # Adicionando um sufixo aleatório
#   acl    = "private"

#   tags = {
#     Name        = "Raw Bucket"
#     Environment = "Dev"
#   }
# }

# resource "aws_s3_bucket" "trusted_bucket" {
#   bucket = "my-trusted-bucket-sprint2-${random_id.bucket_id.hex}"  # Adicionando um sufixo aleatório
#   acl    = "private"

#   tags = {
#     Name        = "Trusted Bucket"
#     Environment = "Dev"
#   }
# }

# # Gerador de ID aleatório para garantir a unicidade do nome do bucket
# resource "random_id" "bucket_id" {
#   byte_length = 8
# }



# # ACL de rede
# resource "aws_network_acl" "acl_publica" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 101
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 102
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 80
#     to_port    = 80
#   }

#   egress {
#     protocol   = "-1"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   tags = {
#     Name = "acl-public"
#   }
# }

# resource "aws_network_acl" "acl_privada" {
#   vpc_id = aws_vpc.main.id

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 101
#     action     = "allow"
#     cidr_block = aws_vpc.main.cidr_block
#     from_port  = 22
#     to_port    = 22
#   }

#   ingress {
#     protocol   = "tcp"
#     rule_no    = 102
#     action     = "allow"
#     cidr_block = aws_vpc.main.cidr_block
#     from_port  = 8080
#     to_port    = 8080
#   }

#   egress {
#     protocol   = "-1"
#     rule_no    = 200
#     action     = "allow"
#     cidr_block = "0.0.0.0/0"
#     from_port  = 0
#     to_port    = 0
#   }

#   tags = {
#     Name = "acl-private"
#   }
# }

# # Associa as ACLs às subnets
# resource "aws_network_acl_association" "acl_association_public" {
#   subnet_id      = aws_subnet.public.id
#   network_acl_id = aws_network_acl.acl_publica.id
# }

# resource "aws_network_acl_association" "acl_association_private" {
#   subnet_id      = aws_subnet.private.id
#   network_acl_id = aws_network_acl.acl_privada.id
# }

# # Outputs
# output "public_ip" {
#   value = aws_instance.public_instance_web_server.public_ip
# }


# output "raw_bucket_name" {
#   value = aws_s3_bucket.raw_bucket.bucket
# }

# output "trusted_bucket_name" {
#   value = aws_s3_bucket.trusted_bucket.bucket
# }


// Nova estrutura de módulos

module "network" {
  source               = "./modules/network"
  vpc_cidr_block       = "10.0.0.0/23"
  public_subnet_cidr   = "10.0.0.0/24"
  private_subnet_cidr  = "10.0.1.0/24"
  availability_zone    = "us-east-1a"
}

module "security" {
  source          = "./modules/security"
  vpc_id          = module.network.vpc_id
  vpc_cidr_block  = "10.0.0.0/23"
}

module "acl" {
  source             = "./modules/acl"
  vpc_id             = module.network.vpc_id
  vpc_cidr_block     = "10.0.0.0/23"
  public_subnet_id   = module.network.public_subnet_id
  private_subnet_id  = module.network.private_subnet_id
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = "ami-04b4f1a9cf54c11d0"
  instance_type      = "t2.micro"
  subnet_id          = module.network.public_subnet_id
  sg_id              = module.security.public_sg_id
  key_name           = "Key-Public-Front-01"
  private_key_path   = "./chaves/Key-Public-Front-01.pem"
  provision_script   = "./scripts/setup.sh"
}


# module "s3" {
#   source = "./modules/s3"
# }
