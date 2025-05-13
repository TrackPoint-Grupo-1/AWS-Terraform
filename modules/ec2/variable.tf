variable "ami_id" {
  description = "ID da AMI para a instância"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "sg_id" {
  description = "ID do security group associado"
  type        = string
}

variable "key_name" {
  description = "Nome da chave SSH EC2"
  type        = string
}

variable "private_key_path" {
  description = "Caminho do arquivo PEM para conectar via SSH"
  type        = string
}

variable "provision_script" {
  description = "Caminho do script de provisionamento local"
  type        = string
}
