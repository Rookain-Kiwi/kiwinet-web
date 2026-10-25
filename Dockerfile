# ── Étape 1 : Build Astro ──────────────────────────────
FROM node:lts-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# ── Étape 2 : Servir avec Nginx Alpine ────────────────
FROM nginx:alpine

# Rattache le paquet GHCR à ce dépôt : c'est ce qui permet au jeton intégré du
# workflow d'y écrire (documentation GitHub, « Labelling container images »)
LABEL org.opencontainers.image.source="https://github.com/Rookain-Kiwi/kiwinet-web"

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80