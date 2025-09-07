# ---- Stage 1: Build ----
FROM node:22-alpine AS builder

# Carpeta de trabajo
WORKDIR /usr/app

# Copiamos package.json (sin exigir package-lock.json)
COPY package.json ./

# Instalamos todas las dependencias (dev incluidas para compilar TS)
RUN npm install

# Copiamos el resto del proyecto
COPY . .

# Compilamos TypeScript
RUN npm run build


# ---- Stage 2: Release ----
FROM node:22-alpine AS release

WORKDIR /usr/app

# Copiamos solo package.json
COPY package.json ./

# Instalamos solo dependencias de producción
RUN npm install --omit=dev

# Copiamos la carpeta compilada desde el builder
COPY --from=builder /usr/app/dist ./dist

# Variables de entorno por defecto
ENV NODE_ENV=production
ENV PORT=3000
ENV STATIC_FILES_PATH=../public
ENV CORS_ORIGIN=*
ENV CORS_METHOD=GET,POST,PUT,DELETE
ENV MONGODB_URI=mongodb://localhost:27017/airbnb
ENV MONGODB_URI_ATLAS=mongodb+srv://mern_user:mern_user@cluster0.irekbbg.mongodb.net/airbnb?retryWrites=true&w=majority&appName=Cluster0

# Exponemos el puerto
EXPOSE ${PORT}

# Comando de arranque
CMD ["node", "dist/index.js"]

