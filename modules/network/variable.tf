variable "vpc_cidr_block" {
  description = "CIDR block da VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR da subnet pública"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR da subnet privada"
  type        = string
}

variable "availability_zone" {
  description = "Zona de disponibilidade (ex: us-east-1a)"
  type        = string
}
