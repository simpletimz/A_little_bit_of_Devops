# DevOps / Cloud Engineering Portfolio

One simple site, taken from a manual deploy through containerization, CI/CD, and (Project 4) full cloud infrastructure on AWS — each project automating what the one before it did by hand.

## Projects

| # | Project | Covers |
|---|---------|--------|
| 1 | [Manual Deploy](./project-1-manual-deploy) | Linux server setup, Nginx, manual deployment |
| 2 | [Docker + Compose](./project-2-docker-compose) | Containerization, Postgres, Docker networking, SSH hardening |
| 3 | [CI/CD Pipeline](./project-3-cicd) | GitHub Actions, Trivy security scanning, automated build/push |
| 4 | Terraform + AWS (in progress) | Infrastructure as Code, cloud deployment, monitoring |

Each project folder has its own `NOTES.md` — a step-by-step guide with exact commands, plus a log of the real issues hit and how they were fixed. Follow them in order to reproduce the whole series yourself.

## Run it yourself

**Just the site, locally with Docker:**
```bash
git clone https://github.com/simpletimz/portfolio-site.git
cd portfolio-site/project-2-docker-compose
docker-compose up -d
```
Visit `http://localhost:8080`.

**The full CI/CD pipeline:**

See [project-3-cicd/NOTES.md](./project-3-cicd/NOTES.md) — set two GitHub secrets, push to `main`, watch it build, scan, and push automatically.

## Stack

VMware Workstation Pro, Ubuntu Server, Nginx, Docker, Docker Compose, Postgres, GitHub Actions, Trivy, Docker Hub — Terraform + AWS coming in Project 4.