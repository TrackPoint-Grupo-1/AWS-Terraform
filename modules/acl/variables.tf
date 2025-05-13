variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR da VPC"
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet pública"
  type        = string
}

variable "private_subnet_id" {
  description = "ID da subnet privada"
  type        = string
}
