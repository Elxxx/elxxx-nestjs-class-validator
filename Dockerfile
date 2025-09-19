# Etapa de build
FROM node:20-alpine AS builder

WORKDIR /app

# Copiamos package.json y lockfile primero (para aprovechar la cache de Docker)
COPY package.json pnpm-lock.yaml* ./

# Instalar pnpm
RUN npm install -g pnpm

# Instalar dependencias
RUN pnpm install --frozen-lockfile

# Copiar todo el código
COPY . .

# Compilar el paquete (usa el script "build" definido en tu package.json)
RUN pnpm build

# Etapa final (solo con el dist)
FROM node:20-alpine

WORKDIR /app

# Copiar solo lo necesario para la librería publicada
COPY --from=builder /app/package.json ./
COPY --from=builder /app/dist ./dist

# Punto de entrada si alguien quiere usarlo dentro de un contenedor
CMD ["node"]
