#!/bin/bash

# Atualizando o sistema e os pacotes
echo "Atualizando pacotes do sistema..."
sudo apt update -y && sudo apt upgrade -y

# Instalando dependências essenciais
echo "Instalando dependências essenciais..."
sudo apt install -y git python3-pip python3-dev python3-venv nginx curl

# Garantindo que o Nginx está instalado
echo "Instalando Nginx..."
sudo apt install -y nginx

# Instalando o Python e as bibliotecas do projeto
echo "Instalando Python3 e pacotes do projeto..."
sudo apt install -y python3-pip python3-venv python3-dev

# Atualizando o pip para a versão mais recente
echo "Atualizando o pip..."
pip3 install --upgrade pip

# Clonando o repositório do projeto
echo "Clonando o repositório do projeto..."
git clone https://github.com/TrackPoint-Grupo-1/Back-End.git /home/ubuntu/repo  # Altere para o repositório correto
cd /home/ubuntu/repo

# Criando e ativando o ambiente virtual Python
echo "Criando e ativando o ambiente virtual Python..."
python3 -m venv venv
source venv/bin/activate

# Instalando as dependências do projeto (Flask, Streamlit, etc.)
echo "Instalando dependências do Python..."
pip install -r /home/ubuntu/repo/requirements.txt  # Certifique-se de que o `requirements.txt` está no repositório

# Instalando o Gunicorn para rodar o Flask
pip install gunicorn

# Instalando o Streamlit
pip install streamlit

# Configurando o Nginx
echo "Configurando o Nginx..."
sudo tee /etc/nginx/sites-available/default > /dev/null <<EOF
server {
    listen 80;
    server_name 44.211.50.151;  # Coloque o seu domínio ou IP público

    # Configuração para o front-end (Streamlit)
    location / {
        proxy_pass http://localhost:8501;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Configuração para o back-end (Flask)
    location /api/ {
        proxy_pass http://localhost:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

# Reiniciando o Nginx para aplicar as configurações
echo "Reiniciando o Nginx..."
sudo systemctl restart nginx

# Rodando o Flask com Gunicorn
echo "Iniciando o servidor Flask com Gunicorn..."
nohup gunicorn -b 0.0.0.0:5000 main_trackpoint:app &  # Altere conforme seu ponto de entrada no Flask

# Rodando o Streamlit
echo "Iniciando o Streamlit..."
nohup streamlit run /home/ubuntu/repo/src/front-end/app.py --server.port 8501 &

echo "Configuração concluída!"
