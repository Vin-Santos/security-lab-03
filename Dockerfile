# ❌ VULNERABILIDADE 1: Usar imagem base desatualizada e com root
FROM node:14

# ❌ VULNERABILIDADE 2: Rodar como root (usuário padrão)
# Sem criar usuário não-privilegiado

# ❌ VULNERABILIDADE 3: Expor informações no build
LABEL maintainer="admin@example.com"
LABEL version="1.0"

# ❌ VULNERABILIDADE 4: Copiar tudo sem .dockerignore
WORKDIR /app
COPY . .

# ❌ VULNERABILIDADE 5: Instalar dependências como root
RUN npm install

# Necessária para o build funcionar
# Altera os sources.list para usar os repositórios arquivados do Debian Buster.
# Isso permite que o apt-get update encontre os pacotes, mantendo a base desatualizada (node:14)
RUN sed -i 's/deb.debian.org/archive.debian.org/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/archive.debian.org/g' /etc/apt/sources.list

# ❌ VULNERABILIDADE 6: Expor porta privilegiada
EXPOSE 80

# ❌ VULNERABILIDADE 7: Não especificar versões, instalar pacotes desnecessários
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    vim \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# ❌ VULNERABILIDADE 8: Rodar aplicação como root
CMD ["npm", "start"]
