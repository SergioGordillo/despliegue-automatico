# Usa Node 22 Alpine
FROM node:22-alpine

# Carpeta de la app
WORKDIR /usr/app

# Copia package.json y package-lock.json para aprovechar cache
COPY package*.json ./

# Instala solo dependencias de producción
RUN npm ci --omit=dev

# Copia el resto del proyecto
COPY . .

# Compila TypeScript
RUN npm run build

# Expone el puerto (usando la variable de entorno)
ENV PORT=3000
EXPOSE ${PORT}

# Variables de entorno necesarias
ENV NODE_ENV=production
ENV STATIC_FILES_PATH=../public
ENV CORS_ORIGIN=*
ENV CORS_METHOD=GET,POST,PUT,DELETE
ENV MONGODB_URI=mongodb://localhost:27017/airbnb
ENV MONGODB_URI_ATLAS=mongodb+srv://mern_user:mern_user@cluster0.irekbbg.mongodb.net/airbnb?retryWrites=true&w=majority&appName=Cluster0

# Comando por defecto para iniciar la app
CMD ["node", "dist/index.js"]

