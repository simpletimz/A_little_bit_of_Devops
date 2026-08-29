# Project 2: Containerization with Docker + Docker Compose

Containerizes the Project 1 site, adds a Postgres database, and runs everything through `docker-compose.yml`. The actual configuration lives in `Dockerfile` and `docker-compose.yml` in this folder — this guide shows you how to run it.

## Prerequisites
- The Ubuntu Server VM from Project 1, reachable over SSH
- Docker not yet installed (installed in Part B below)

## Part A — Harden SSH access (do this once)
By default, SSH asks for a password every time you log in. Replacing this with a key pair means you log in automatically, without typing a password — and it's how real servers reconnect after a reboot with no one present to type anything.

**1. Generate a key pair on your host machine (not the VM)**
```bash
ssh-keygen -t ed25519
```
Press Enter through the prompts to accept the defaults.

**2. Copy your public key onto the server**
View your public key on your host(ensure you see C:\Users\user\):
```bash
cd .ssh/
dir
type id_ed25519.pub
```
(Windows PowerShell — copy the full line it prints.)

SSH into the VM as usual, then:
```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
```
Paste the key in, save, and exit (`Ctrl+O`, `Enter`, `Ctrl+X`).

**3. Lock down permissions on the file**
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

**4. Test it**
From your host:
```bash
ssh <username>@<vm-ip>
```
You should log in with no password prompt.

## Part B — Install Docker
```bash
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER
```
Log out and back in for the last command to take effect (exit out of vscode terminal incase you made a mistake just ssh back in), then confirm:
```bash
docker --version
docker ps
```
This should run without needing `sudo`.

## Part C — Run the site with Docker Compose
**1. Clone this repo and enter the project folder**
```bash
git clone https://github.com/simpletimz/portfolio-site.git
cd portfolio-site/project-2-docker-compose
```

**2. Start everything**
```bash
docker-compose up -d
```
This reads `docker-compose.yml` and builds the site's image from `Dockerfile`, pulls Postgres, creates a shared network, creates a storage volume for the database, and starts both containers connected to each other.

**3. Confirm both containers are running**
```bash
docker-compose ps
```
Both should show `Up`.

**4. View the site**

Visit `http://<vm-ip>:8080` in your browser.

**5. Confirm the database works and data survives a restart**
```bash
docker exec -it portfolio-db psql -U postgres -d portfoliodb
```
Inside the prompt:
```sql
CREATE TABLE test (id SERIAL PRIMARY KEY, note TEXT);
INSERT INTO test (note) VALUES ('hello from my homelab');
SELECT * FROM test;
\q
```
Then tear down and rebuild the containers, and check the data is still there:
```bash
docker-compose down
docker-compose up -d
docker exec -it portfolio-db psql -U postgres -d portfoliodb -c "SELECT * FROM test;"
```
The row should still be present — the data lives in a Docker volume, independent of the container itself.

## Files in this folder
- `Dockerfile` — builds the site's image
- `docker-compose.yml` — defines both containers, the network, and the volume
- `index.html` — the site content (also used by Project 1)

## What I'd change for a real production deployment
Add a healthcheck so the app waits for the database to be fully ready, not just started.
Move the database password out of docker-compose.yml into a .env file excluded from version control.
Use a private container registry instead of building locally (see Project 3).