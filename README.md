# **Instruções para Rodar o Projeto**

Este guia irá te ajudar a rodar o script Terraform na sua máquina local. Ele abrange desde a instalação de ferramentas essenciais até a configuração do ambiente AWS e execução do projeto.

## **Passo 1: Pré-requisitos**

### **1.1 Instalar o WSL (Windows Subsystem for Linux)**

Caso você ainda não tenha o **WSL** instalado, siga os passos abaixo para instalá-lo:

1. Abra o PowerShell como administrador e execute o comando:

   ```bash
   wsl --install
   ```
2. Após a instalação, reinicie sua máquina.
3. Instale uma distribuição do Linux (ex: Ubuntu) da Microsoft Store.

### **1.2 Instalar o AWS CLI**

O **AWS CLI** é necessário para interagir com os serviços da AWS a partir do seu terminal.

1. Abra o terminal do **WSL**.

2. Execute os seguintes comandos para instalar o AWS CLI:

   ```bash
   sudo apt update
   sudo apt install awscli
   ```

3. Verifique a instalação executando:

   ```bash
   aws --version
   ```

### **1.3 Instalar o Terraform**

O **Terraform** é a ferramenta utilizada para criar, modificar e versionar a infraestrutura da AWS.

1. No terminal do **WSL**, execute os seguintes comandos para instalar o Terraform:

   ```bash
   sudo apt update
   sudo apt install wget unzip
   wget https://releases.hashicorp.com/terraform/1.4.5/terraform_1.4.5_linux_amd64.zip
   unzip terraform_1.4.5_linux_amd64.zip
   sudo mv terraform /usr/local/bin/
   ```

2. Verifique se o Terraform foi instalado corretamente:

   ```bash
   terraform --version
   ```

### **1.4 Gerar as Chaves SSH**

O script utiliza chaves SSH para acessar as instâncias EC2. Siga os passos abaixo para gerar as chaves:

1. No terminal do **WSL**, execute o comando para gerar uma chave SSH:

   ```bash
   ssh-keygen -t rsa -b 2048 -f ~/my-aws-key
   ```

2. Durante o processo, **não defina uma senha** (pressione Enter para continuar sem senha).

3. Sua chave privada estará em `~/my-aws-key` e a chave pública em `~/my-aws-key.pub`.

### **1.5 Clonar o Repositório**

Agora, você precisa clonar o repositório para sua máquina local.

1. No terminal do **WSL**, navegue até o diretório onde deseja clonar o repositório:

   ```bash
   cd ~
   ```

2. Clone o repositório:

   ```bash
   git clone https://github.com/usuario/seu-repositorio.git
   ```

   **Substitua** `https://github.com/usuario/seu-repositorio.git` pela URL do repositório que você vai utilizar.

3. Navegue até o diretório do repositório clonado:

   ```bash
   cd seu-repositorio
   ```

### **1.6 Configurar Credenciais da AWS**

Agora, você precisa configurar suas credenciais da AWS para que o Terraform possa interagir com a AWS.

1. No terminal do **WSL**, execute o comando:

   ```bash
   aws configure
   ```

   Isso pedirá para você inserir sua **AWS Access Key** e **AWS Secret Key**.

2. Se você não tiver as credenciais, faça o login no **[AWS Console](https://aws.amazon.com/console/)** e crie uma chave de acesso na seção **IAM**.

3. Após obter a chave de acesso e a chave secreta, configure suas credenciais no **arquivo `credentials`**.

   Execute o comando para editar o arquivo de credenciais:

   ```bash
   nano ~/.aws/credentials
   ```

   O arquivo deve ter a seguinte estrutura:

   ```ini
   [default]
   aws_access_key_id = SUA_ACCESS_KEY
   aws_secret_access_key = SUA_SECRET_KEY
   region = us-east-1
   ```

   **Substitua** `SUA_ACCESS_KEY` e `SUA_SECRET_KEY` pelos valores da sua chave.

   **Salve e feche** o arquivo no nano com `CTRL + O` e `CTRL + X`.

---

## **Passo 2: Entendendo os Módulos**

Este repositório foi estruturado em **módulos** para facilitar o gerenciamento da infraestrutura na AWS.

### **2.1 Estrutura do Projeto**

O projeto contém os seguintes módulos:

1. **/network**:

   * **Cria a VPC**, **subnets** pública e privada, **internet gateway**, **NAT Gateway**, **tabelas de rotas**, e **associações de roteamento**.

2. **/ec2**:

   * **Cria instâncias EC2** públicas, configura **provisioners** para configurar as instâncias e configura **chaves SSH** para acesso remoto.

3. **/security**:

   * **Cria grupos de segurança** para controlar o tráfego de rede entre as instâncias EC2.

4. **/acl**:

   * **Cria ACLs de rede** para controlar o tráfego em nível de sub-rede.

5. **/s3**:

   * **Cria buckets S3** para armazenar dados.

### **2.2 Explicação do `main.tf`**

O arquivo `main.tf` é responsável por orquestrar a criação da infraestrutura, chamando os módulos acima mencionados e passando as variáveis necessárias para cada um deles.

---

## **Passo 3: Executando o Script**

Agora que você configurou todas as ferramentas e as credenciais, é hora de rodar o Terraform para provisionar a infraestrutura na AWS.

### **3.1 Inicializar o Terraform**

1. No terminal, dentro do diretório do repositório clonado, inicialize o Terraform:

   ```bash
   terraform init
   ```

   Esse comando baixará os plugins necessários e preparará o ambiente para a execução.

### **3.2 Rodar o Terraform Plan**

Antes de aplicar as mudanças, execute o comando `terraform plan` para revisar o que será criado/modificado:

```bash
terraform plan
```

### **3.3 Aplicar as Mudanças**

Se o `terraform plan` estiver correto, aplique as mudanças com o comando:

```bash
terraform apply
```

Digite `yes` para confirmar a execução.

### **3.4 Verificar a Infraestrutura**

Após a execução, o Terraform criará a infraestrutura na AWS. Você pode verificar os recursos (como as instâncias EC2, VPC, etc.) diretamente no **[Console da AWS](https://console.aws.amazon.com/)**.

---

## **Passo 4: Limpeza da Infraestrutura**

Se você deseja **remover** todos os recursos provisionados, basta rodar o comando:

```bash
terraform destroy
```

Digite `yes` para confirmar a destruição dos recursos.

---

## **Passo 5: Dicas e Considerações Finais**

* **Controle de versão**: Sempre use o `.gitignore` para evitar versionar chaves privadas e arquivos sensíveis.
* **Ambientes de produção**: Evite usar as credenciais da AWS diretamente no código. Considere usar **AWS IAM roles** e **AWS Secrets Manager** para credenciais.
* **Segurança**: Tenha cuidado com suas credenciais e nunca as compartilhe publicamente.

---

## **Conclusão**

Seguindo esse guia, seus colegas poderão rodar o projeto na máquina local, interagir com a AWS e provisionar a infraestrutura necessária. Se tiverem alguma dúvida, basta seguir as instruções ou entrar em contato.

Boa sorte! 🚀
