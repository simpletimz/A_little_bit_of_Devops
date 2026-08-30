# Project 3: CI/CD Pipeline with GitHub Actions

Automatically builds the site's Docker image, scans it for vulnerabilities with Trivy, and pushes it to Docker Hub every time code is pushed to `main`. The actual pipeline lives in `.github/workflows/deploy.yml` at the repo root — this guide shows you how to set it up and what to expect.

## Prerequisites
- A Docker Hub account
- This repo pushed to your own GitHub account, with Actions enabled

## Steps
**1. Create a Docker Hub access token**
Create a Docker Hub account if you do not have one.
Docker Hub → Account Settings → Security → New Access Token. Choose a name like `git-cli-access` then set it to **Read & Write** permissions. Copy the token immediately — it's shown once. Make a note somewhere safe; you cannot view it again after this screen.

**2. Add repository secrets on GitHub**
You create your own repo from this one. If you're learning the ropes, this is a good place to get familiar with GitHub — cloning, pushing, and managing your own repository are all important skills here.

Your repo → Settings → Secrets and variables → Actions → New repository secret. Add two secrets:
- `DOCKERHUB_USERNAME` → your Docker Hub username
- `DOCKERHUB_TOKEN` → the token from Step 1

The first secret's **Name** field should read `DOCKERHUB_USERNAME`, and its **Secret** field should hold your real Docker Hub username. Same process for the token — Name: `DOCKERHUB_TOKEN`, Secret: the actual token string.

**3. Push to `main`**
In your VS Code terminal:
```bash
git add .
git commit -m "trigger pipeline"
git push origin main
```

**4. Watch it run**
Go to your repo on GitHub itself → Actions tab → click the running workflow. You'll see four steps: checkout, build, scan, push.

**5. Check the result**
- **Green:** image is now live on Docker Hub under `<your-username>/portfolio-site`, tagged with both the commit SHA and `latest`. **yellow** means running workflows.
- **Red on the scan step:** Trivy found a CRITICAL or HIGH vulnerability and stopped the pipeline before pushing anything. Click into the step to read the report and see which package/CVE caused it. If you're just trying out CI/CD, it can be faster to paste the error into an LLM (Claude, ChatGPT) to help diagnose it. LLMs can also teach you a lot along the way — stay open-minded and ask when you feel lost.

## The pipeline
See [`.github/workflows/deploy.yml`](../.github/workflows/deploy.yml) at the repo root for the actual workflow. Four steps: checkout, build, scan, push. Images are tagged with the git commit SHA, not just `latest`, so every build is traceable to the exact code that produced it.

## Real issues hit while building this
**Self-hosted runner + public repo warning.** A self-hosted runner (running on your own VM instead of GitHub's cloud) was set up initially, then abandoned because public repos with self-hosted runners are vulnerable to malicious fork pull requests executing code on your machine. Switched to a standard GitHub-hosted runner so this repo could safely be made public. GitHub does offer mitigations (requiring approval on fork PRs before they run), but since this repo may also be used as a learning reference by other beginners, defaulting to the safer setup made more sense than managing that risk manually.

**Git authentication chain of failures:**
- `GIT_ASKPASS` pointed at an unreachable VS Code helper socket → fixed with `unset GIT_ASKPASS`
- GitHub rejects account passwords for git operations → required a Personal Access Token (PAT)
- PAT was missing the `workflow` scope, which is required specifically to modify files in `.github/workflows/` → regenerated the token with `repo` + `workflow` scopes
- Divergent local/remote history after editing `.github` on GitHub's web UI → resolved with `git config pull.rebase false`, `git pull origin main`, then manually resolving a rename/delete merge conflict

**Pinned Trivy action version stopped existing** (`0.24.0` not found). The action's maintainers migrated all tags to a `v`-prefixed scheme after a supply-chain security incident affecting the project. Updated my pin to `v0.35.0` to match.

**Trivy found 189 vulnerabilities (42 CRITICAL) on the first real scan.** Root cause: the pinned base image, `nginx:1.18.0`, runs on Debian 10 — a release that had reached end-of-life and stopped receiving security patches. Fixed in two stages:
1. Switched the base image to `nginx:1.27-alpine` → down to 35 vulnerabilities (2 CRITICAL)
2. Added a package upgrade step to the Dockerfile so it always pulls the latest patches available at build time:
   ```dockerfile
   RUN apk update && apk upgrade --no-cache
   ```
   → down to 0 vulnerabilities

## What I'd change for a real production deployment

- Extend the pipeline to actually deploy the image somewhere reachable, not just push to a registry (see Project 4).
- Add a `.trivyignore` with documented justification for any future vulnerability with no available fix yet, instead of leaving the pipeline permanently failing.
- Move from Docker Hub to a cloud-native private registry (AWS ECR) once deploying to AWS.