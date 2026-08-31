# DevOps / Cloud Engineering Portfolio

One simple site, taken from a manual deploy through containerization, CI/CD, and full cloud infrastructure on AWS — each project automating what the one before it did by hand.

## Projects

| # | Project | Covers |
|---|---------|--------|
| 1 | [Manual Deploy](./project-1-manual-deploy) | Linux server setup, Nginx, manual deployment |
| 2 | [Docker + Compose](./project-2-docker-compose) | Containerization, Postgres, Docker networking, SSH hardening |
| 3 | [CI/CD Pipeline](./project-3-cicd) | GitHub Actions, Trivy security scanning, automated build/push |
| 4 | [Terraform + AWS](./project-4-terraform-aws) | Infrastructure as Code, EC2, IAM, SSM-based deployment, full automation from `git push` to a live public site |

Each project folder has its own `NOTES.md` — a step-by-step guide with exact commands, plus a log of the real issues hit and how they were fixed along the way. Follow them in order to reproduce the whole series yourself.

CI history on this repo includes real failed runs, not just green ones — each project's `NOTES.md` documents what broke and how it was diagnosed and fixed.

## Run it yourself

**Just the site, locally with Docker:**
```bash
git clone https://github.com/simpletimz/portfolio-site.git
cd portfolio-site/project-2-docker-compose
docker-compose up -d
```
Visit `http://<vm-ip>:8080` (or `http://localhost:8080` if Docker is running on the same machine you're browsing from).

**The full CI/CD pipeline (build, scan, push to Docker Hub):**

See [project-3-cicd/NOTES.md](./project-3-cicd/NOTES.md) — set two GitHub secrets, push to `main`, watch it build, scan, and push automatically.

**Full deployment to AWS (provision infrastructure + automated deploy on every push):**

See [project-4-terraform-aws/NOTES.md](./project-4-terraform-aws/NOTES.md) — provision an EC2 instance with Terraform, then the same pipeline above deploys to it automatically via AWS Systems Manager, with no SSH port exposed to CI.

## Stack

VMware Workstation Pro, Ubuntu Server, Nginx, Docker, Docker Compose, Postgres, GitHub Actions, Trivy, Docker Hub, Terraform, AWS (EC2, IAM, Systems Manager, Elastic IP).