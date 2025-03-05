variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
}

variable "subnet_id" {
  description = "ID da Subnet onde a instância será criada"
  type        = string
}

variable "security_group_id" {
  description = "ID do Security Group associado à instância"
  type        = string
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acesso"
  type        = string
}
variable "availability_zone" {
  description = "Zona de disponibilidade da instância EC2"
  type        = string
  default     = "us-east-1a"
}
variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod)"
  type        = string
}

