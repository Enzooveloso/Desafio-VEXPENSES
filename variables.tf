variable "environment" {
  description = "Nome do ambiente (ex: dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t2.micro"
}

variable "availability_zone" {
  description = "Zona de disponibilidade da AWS"
  type        = string
  default     = "us-east-1a"
}

variable "ssh_public_key" {
  description = "Chave pública SSH para acessar a instância"
  type        = string
}
