# kiwinet-web

Site principal de `Kiwinet` — construit avec Astro, servi via Nginx Alpine, déployé automatiquement sur la VM.

---

## Rôle de ce repo

Ce repo contient le code source du site public `Kiwinet`. Il fait partie de l'infrastructure kiwinet :

| Repo                 | Rôle                                  | URL déployée         |
|----------------------|---------------------------------------|----------------------|
| `kiwinet-infra`      | Services, reverse proxy, domotique    | —                    |
| **`kiwinet-web`**    | Site principal Astro + Nginx          | `kiwinet.me`         |
| `kiwinet-status`     | Page de statut Uptime Kuma            | `status.kiwinet.me`  |
| `kiwinet-monitoring` | Stack Prometheus / Loki / Grafana     | `grafana.kiwinet.me` |

---

## Stack

- **Astro** — générateur de site statique
- **Nginx Alpine** — serveur HTTP dans le container
- **Docker + GHCR** — image buildée en CI, taguée `latest` et `<sha>`
- **Traefik** — reverse proxy TLS (géré dans `kiwinet-infra`)

---

## Structure

```
kiwinet-web/
├── src/
│   └── pages/          ← Pages Astro (index.astro, ...)
├── public/             ← Assets statiques (images, favicons...)
├── Dockerfile          ← Build multi-stage : Astro → Nginx Alpine
├── docker-compose.yml  ← Déploiement sur la VM (labels Traefik)
└── .github/
    └── workflows/
        └── deploy.yml  ← Pipeline CI/CD GitHub Actions
```

---

## CI/CD

Le déploiement est entièrement automatisé à chaque push sur `main` :

```
git push origin main
    │
    ▼
GitHub Actions (ubuntu-latest)
    │
    ├── Docker Buildx → build linux/arm64
    ├── Push GHCR : ghcr.io/rookain-kiwi/kiwinet-web:latest
    │                ghcr.io/rookain-kiwi/kiwinet-web:<sha>
    │
    └── SSH → VM
            ├── git pull
            ├── docker compose pull website
            └── docker compose up -d website
```

**Secrets GitHub Actions requis :**

| Secret            | Description                              |
|-------------------|------------------------------------------|
| `GHCR_TOKEN`      | Token GitHub avec scope `write:packages` |
| `DEPLOY_HOST`     | IP ou hostname de la VM                  |
| `DEPLOY_USER`     | Utilisateur SSH sur la VM                |
| `DEPLOY_SSH_KEY`  | Clé privée SSH (sans passphrase)         |

---

## Développement local

```bash
npm install

# Serveur de développement (hot reload)
npm run dev

# Build de production
npm run build

# Prévisualiser le build
npm run preview
```

---

## Déploiement manuel

En cas de besoin, déploiement direct depuis la VM :

```bash
cd /opt/kiwinet-web
git pull
docker compose pull website
docker compose up -d website
```
