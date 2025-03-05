#  Desafio Online da VEXPENSES -  Infraestrutura como Código (IaC) utilizando Terraform

# Tarefa 1

## Descrição Detalhada do Arquivo `main.tf` antes de ser modificado

O arquivo `main.tf` define a infraestrutura básica na AWS utilizando o Terraform. Ele cria e configura os principais recursos necessários para uma instância EC2 funcional e acessível. A infraestrutura inclui:

- **VPC**: Para isolar a rede.
- **Subnet**: Dentro da VPC para segmentação.
- **Internet Gateway**: Para permitir a conexão externa.
- **Tabela de Rotas**: Para direcionar o tráfego.
- **Security Group**: Para controlar o tráfego de entrada e saída.
- **Par de Chaves SSH**: Para acesso seguro.
- **Instância EC2**: Para executar as aplicações.

## Configuração da Instância

A configuração permite que a instância EC2 receba um IP público, possibilitando o acesso remoto via SSH. Um script de inicialização (`user_data`) é utilizado para atualizar e instalar pacotes do sistema automaticamente.

## Provedor e Variáveis

O arquivo especifica a AWS como provedora de infraestrutura e define a região `us-east-1` para a criação dos recursos. Além disso, são usadas variáveis para nomear os recursos, o que torna o código mais flexível e reutilizável.

## Rede e Conectividade

A infraestrutura cria uma VPC com suporte a resolução de nomes DNS, assim os recursos dentro da rede possam se comunicar de forma eficiente.

- **Subnet**: Configurada dentro da VPC na zona de disponibilidade `us-east-1a`.
- **Internet Gateway**: Associado à VPC para permitir o acesso à internet.
- **Tabela de Rotas**: Criada para rotear o tráfego externo através do Internet Gateway associada à subnet.

## Segurança e Acesso

A segurança da infraestrutura é gerenciada por um Security Group, que define regras de entrada e saída para a instância EC2. A configuração inicial permite conexões SSH (porta 22) de qualquer IP, o que representa um risco de segurança, pois qualquer pessoa pode tentar acessar a instância.

Além disso, é gerado um par de chaves SSH:

- **Chave pública**: Associada à instância EC2 para permitir o acesso remoto.
- **Chave privada**: Utilizada para o acesso remoto via SSH.

## Instância EC2

A instância EC2 utiliza a AMI mais recente do Debian 12, garantindo compatibilidade com pacotes atualizados. O tipo de instância escolhido é `t2.micro`, adequado para testes e aprendizado, além de ser compatível com o AWS Free Tier.

- A instância é configurada para receber um IP público automaticamente.
- Um script de inicialização (`user_data`) é executado para atualizar os pacotes do sistema ao iniciar a instância.

## Outputs

O código define dois outputs importantes:

- **Chave privada SSH**: Necessária para acessar a instância.
- **IP público da EC2**: Utilizado para a conexão remota via SSH.

## Observações

- **Security Group**: Permite conexões SSH de qualquer IP, o que representa um risco de segurança, pois qualquer pessoa pode tentar acessar a instância.
- **Regra de egress**: Permite tráfego irrestrito (`0.0.0.0/0`), mas essa configuração pode ser mais restritiva dependendo da aplicação.

## Gerenciamento da Chave SSH

O código gera uma chave SSH privada dinamicamente, mas o único local onde ela aparece é na saída (`output "private_key"`). Caso o usuário não salve essa chave ao rodar o Terraform pela primeira vez, ele não conseguirá acessar a instância depois. Uma alternativa seria:

- Armazenar a chave em um **Secrets Manager**.
- Permitir que o usuário forneça uma chave SSH manualmente.

## Organização e Rastreabilidade

Há poucas tags associadas aos recursos, o que pode dificultar a organização e rastreamento dentro da AWS. Adicionar tags aos recursos ajudaria na gestão e localização dos mesmos.


# Tarefa 2
## Explicando as melhorias implementadas e justificando-as

O código foi modularizado para melhorar organização, reutilização e manutenção.

### Melhorias Implementadas e Justificativas

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

#  Instruções de Uso

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

