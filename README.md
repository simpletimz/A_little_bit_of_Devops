# Project 1: Manual Deployment

## What this is

A manual deployment of a simple static site to a Linux server, done without any automation — no Docker, no CI/CD, no Infrastructure as Code. The goal of this project isn't the site itself; it's understanding **exactly what a deployment pipeline automates**, by doing every step by hand first.

This is Project 1 in a series building toward a full DevOps/cloud pipeline:
- **Project 1:** manual deploy — understand the fundamentals
- **Project 2:** containerize the same app with Docker + deploy to a local Kubernetes cluster (k3s)
- **Project 3:** automate build/test/scan/deploy with a CI/CD pipeline
- **Project 4:** provision equivalent infrastructure on AWS with Terraform, add monitoring

## Architecture

```
Browser (host machine)
      |
      | HTTP :80
      v
Ubuntu Server VM (VMware, NAT network)
      |
      v
  Nginx (web server)
      |
      v
  /var/www/html (static site content)
```

## Stack

- **Host:** Windows, VMware Workstation Pro
- **VM:** Ubuntu Server (NAT networking)
- **Web server:** Nginx
- **Source control:** Git / GitHub

## Steps taken

1. **Provisioned an Ubuntu Server VM** in VMware Workstation Pro, using NAT networking.
2. **Enabled SSH access** (`openssh-server`) so the VM could be managed remotely from the host via terminal or VS Code Remote-SSH, rather than working directly in the VM console.
3. **Updated the system** (`sudo apt update && sudo apt upgrade -y`) to ensure packages installed from a current index, avoiding outdated or vulnerable versions.
4. **Installed Nginx** (`sudo apt install nginx -y`), a web server chosen for its event-driven architecture (handles many concurrent connections efficiently) and its role as the standard "front door" component in most real-world architectures — web server, reverse proxy, load balancer, and TLS terminator in one.
5. **Verified the service** was running (`systemctl status nginx`) and reachable from the host browser over the NAT network using its IP Address — confirming the full path from browser → network → VM → Nginx process, not just that the process existed.
6. **Created a separate GitHub repo** for the site content, simulating a developer handing off finished code — rather than hand-authoring the site directly on the server, which wouldn't reflect a real DevOps workflow.
7. **Cloned the repo onto the server** into a temporary directory (`/tmp`), then copied just the site's content (not the `.git` history) into Nginx's document root (`/var/www/html`) — keeping the web root clean of version-control metadata, consistent with how real deploy tooling separates "build artifact" from "source repo."
8. **Verified the deployed site** was reachable from the host browser at the VM's IP. Type the IP address into the host browser (chrome). You can check your server IP using (ip a)

## Why manual first

Every later project in this series automates one or more of these steps. Doing them by hand first means the automation (Docker, CI/CD, Terraform) is understood as *"the thing that does what I just did, reliably and repeatedly"* — not unfamiliar tooling learned in isolation.

## What I'd change for a real production deployment

- Use a proper deploy user with least-privilege permissions rather than `sudo` for file operations.
- Automate this entire flow via CI/CD (Project 3) rather than manual SSH + copy.
- Use `rsync` instead of `cp` for any future manual syncs, since it only transfers changed files.
- Add a firewall (`ufw`) policy explicitly allowing only required ports (80/443/22), rather than relying on defaults.