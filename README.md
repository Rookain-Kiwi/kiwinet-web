# kiwinet-web

Site portfolio de Kiwinet — construit avec Astro, servi via Nginx Alpine, déployé automatiquement.

> Contexte global : [kiwinet-docs](https://github.com/Rookain-Kiwi/kiwinet-docs)

---

## Stack

- **Astro** — générateur de site statique
- **Nginx Alpine** — serveur HTTP dans le container
- **Docker + GHCR** — image buildée en CI, taguée `latest` et `<sha>`
- **Traefik** — reverse proxy TLS (géré dans `kiwinet-services`)

---

## Structure

```
kiwinet-web/
├── src/
│   └── pages/              # Pages Astro
├── public/                 # Assets statiques
├── Dockerfile              # Build multi-stage : Astro → Nginx Alpine
├── docker-compose.yml      # Déploiement VM (labels Traefik)
└── .github/workflows/
    └── deploy.yml          # Pipeline CI/CD
```

---

## CI/CD

Déclenché automatiquement à chaque push sur `main` :

```
git push origin main
    ↓
GitHub Actions :
  ├── docker build (linux/arm64 via QEMU/Buildx)
  ├── push GHCR : ghcr.io/rookain-kiwi/kiwinet-web:latest + :<sha>
  └── SSH → VM → docker compose pull + up -d
```

**Secrets GitHub Actions requis :**

| Secret           | Description                           |
|------------------|---------------------------------------|
| `GHCR_TOKEN`     | Token GitHub — scope `write:packages` |
| `DEPLOY_HOST`    | Hostname ou IP de la VM               |
| `DEPLOY_USER`    | Utilisateur SSH sur la VM             |
| `DEPLOY_SSH_KEY` | Clé privée SSH dédiée au déploiement  |

---

## Développement local

```bash
npm install
npm run dev      # Serveur local avec hot reload
npm run build    # Build de production
npm run preview  # Prévisualiser le build
```

---

## Déploiement manuel

```bash
cd /opt/kiwinet-web
git pull
docker compose pull website
docker compose up -d website
```
