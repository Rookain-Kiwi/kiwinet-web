# kiwinet-web

Site portfolio de Kiwinet — construit avec Astro, servi via Nginx Alpine, déployé automatiquement sur VPS Scaleway.

> Contexte global : [kiwinet-docs](https://github.com/Rookain-Kiwi/kiwinet-docs)

---

## Stack

- **Astro** — générateur de site statique
- **Nginx Alpine** — serveur HTTP dans le container
- **Docker + GHCR** — image buildée en CI, taguée `latest` et `<sha>`
- **Traefik** — reverse proxy TLS sur le VPS Scaleway (géré dans `kiwinet-services`)

---

## Structure

```
kiwinet-web/
├── src/
│   └── pages/
│       ├── index.astro             # Accueil FR
│       ├── about.astro             # À propos FR
│       ├── projects.astro          # Projets FR
│       ├── stack.astro             # Stack technique FR
│       ├── contact.astro           # Contact FR
│       ├── projects/
│       │   └── ecf-notation.astro  # Notation ECF Infoline FR
│       └── en/                     # Pages EN (même structure)
│           └── projects/
│               └── ecf-notation.astro
├── public/
│   ├── cv.pdf                      # CV FR (EN à venir)
│   ├── pitch.mp4                   # Pitch vidéo FR (EN à venir)
│   ├── ala-atrash.jpg              # Photo évaluateur ECF
│   ├── ala-atrash.mp3              # Extrait audio notation ECF
│   └── ecf-corrige.pdf             # Copie corrigée ECF (autorisé par l'évaluateur)
├── Dockerfile                      # Build multi-stage : Astro → Nginx Alpine
├── docker-compose.yml              # Déploiement VPS Scaleway (labels Traefik)
├── docker-compose.vm.yml           # Config Freebox (legacy, non utilisée en CI)
└── .github/workflows/
    └── deploy.yml                  # Pipeline CI/CD
```

---

## CI/CD

Déclenché automatiquement à chaque push sur `main` :

```
git push origin main
    ↓
GitHub Actions :
  ├── docker build (linux/amd64)
  ├── push GHCR : ghcr.io/rookain-kiwi/kiwinet-web:latest + :<sha>
  └── SSH → VPS Scaleway (port 2222) → docker compose pull + up -d
```

**Secrets GitHub Actions requis :**

| Secret           | Description                                      |
|------------------|--------------------------------------------------|
| `GHCR_TOKEN`     | Token GitHub — scope `write:packages`            |
| `DEPLOY_HOST`    | IP ou hostname du VPS Scaleway                   |
| `DEPLOY_PORT`    | Port SSH du VPS (2222)                           |
| `DEPLOY_USER`    | Utilisateur SSH sur le VPS                       |
| `DEPLOY_SSH_KEY` | Clé privée SSH dédiée au déploiement (`kiwinet_deploy`) |

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
# Depuis le VPS Scaleway
cd /opt/kiwinet-web
git pull
docker compose pull website
docker compose up -d website
```
