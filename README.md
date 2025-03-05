#  Desafio Online da VEXPENSES -  Infraestrutura como Código (IaC) utilizando Terraform

##  Descrição Técnica

### Visão Geral do `main.tf`
O código Terraform define uma infraestrutura na **AWS**, provisionando os seguintes recursos:

- **VPC**: Rede isolada para os recursos.
- **Subnet**: Segmento de rede dentro da VPC.
- **Security Group**: Firewall para controle de tráfego.
- **EC2**: Instância de servidor com Debian 12 e Nginx instalado automaticamente.
- **Chaves SSH**: Gerenciamento seguro do acesso remoto.

O código foi modularizado para melhorar organização, reutilização e manutenção.

### Melhorias Implementadas e Justificativas**

Foram aplicadas diversas melhorias no código original para torná-lo mais seguro, reutilizável e alinhado às boas práticas do Terraform e DevOps. As mudanças foram necessárias para melhorar:

✅ **Segurança Aprimorada**
- Antes, o SSH estava aberto para qualquer IP (`0.0.0.0/0`), o que é um risco. Agora, o acesso é restrito a um IP configurável pelo usuário.
- O Security Group agora possui regras mais restritivas, permitindo apenas tráfego essencial.

✅ **Automação**
- Antes, a instância EC2 não tinha configuração automatizada.
- Agora, o **Nginx é instalado automaticamente** via `user_data`, garantindo que o servidor esteja pronto assim que for provisionado.

✅ **Modularização**
- Antes, tudo estava em um único arquivo `main.tf`, dificultando manutenção e reutilização.
- Agora, os recursos foram separados em **módulos (`vpc`, `security-group`, `ec2`)**, tornando o código mais organizado e reutilizável.

✅ **Variáveis Reutilizáveis**
- Foram criadas variáveis para **`instance_type`**, **`availability_zone`** e **`environment`**.
- Isso permite configurar a infraestrutura facilmente sem alterar o código-fonte diretamente.

✅ **Melhor Organização**
- A separação dos arquivos `variables.tf`, `outputs.tf` e `main.tf` na raiz do projeto facilita a leitura e evita hardcoding de valores.
- Tags foram adicionadas para melhor gerenciamento dos recursos na AWS.

Essas mudanças tornam o código mais **seguro, escalável e alinhado às boas práticas**. Além disso, garantem que a infraestrutura possa ser **facilmente ajustada para diferentes ambientes** sem precisar modificar o código diretamente.

##  Código `main.tf`
```hcl
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
}

module "security_group" {
  source    = "./modules/security-group"
  vpc_id    = module.vpc.vpc_id
}

module "ec2" {
  source            = "./modules/ec2"
  instance_type     = var.instance_type
  subnet_id         = module.vpc.subnet_id
  security_group_id = module.security_group.security_group_id
  ssh_public_key    = var.ssh_public_key
  environment       = var.environment
}
```

##  Instruções de Uso

### **1️⃣ Pré-requisitos**
Para executar o Terraform localmente, você precisa:
- **Terraform** instalado ([Instruções](https://developer.hashicorp.com/terraform/downloads)).
- Chave SSH pública (`~/.ssh/id_rsa.pub` ou equivalente).
- (Opcional) Conta na AWS configurada (`aws configure`).

### **2️⃣ Inicializando o Terraform**
No diretório do projeto, execute:

```bash
terraform init  
terraform validate  
terraform plan  
```

### **3️⃣ Aplicando a Infraestrutura**
Se tudo estiver correto, aplique as mudanças:

```bash
terraform apply
```

Caso o Terraform peça a chave SSH, passe manualmente:

```bash
terraform apply -var="ssh_public_key=$(cat ~/.ssh/id_rsa.pub)"
```


## Conclusão
Este projeto implementa uma infraestrutura AWS segura e modularizada utilizando Terraform. A separação em módulos melhora a organização, reutilização e escalabilidade do código. As melhorias foram implementadas afim de garantir maior segurança, automação e flexibilidade, tornando a infraestrutura mais robusta para diferentes cenários.

