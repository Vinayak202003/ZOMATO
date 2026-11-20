# Stage 1: Build React application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

# Bypass CRA ESLint dependency preflight check
ENV SKIP_PREFLIGHT_CHECK=true

RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# Stage 2: Serve using Nginx
FROM nginx:alpine

COPY --from=builder /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
