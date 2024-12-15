# Build do app em React
FROM node:18-alpine AS build
 
WORKDIR /app
 
COPY package*.json ./
 
RUN npm ci
 
COPY . .

# Necessário expor a variável de ambiente para o build
ARG REACT_APP_BACKEND_URL
ENV REACT_APP_BACKEND_URL=${REACT_APP_BACKEND_URL}

RUN npm run build

# Serve o app com Nginx
FROM nginx:stable-alpine AS production

COPY --from=build /app/build /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/nginx.conf

EXPOSE 80/tcp

CMD ["nginx", "-g", "daemon off;"]