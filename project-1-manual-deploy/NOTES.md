# Project 1: Manual Deployment

Manually deploy a static site to a bare Linux server — no Docker, no automation. This project establishes what every later project in this series automates.

## Prerequisites

This guide assumes you already have a virtual machine set up on your laptop (VMware Workstation Pro is preferred).

- **Ubuntu Server** installed as your VM — download it from https://ubuntu.com/download/server
- **Visual Studio Code (VS Code)** — install this on your host machine (your laptop), not the VM. You'll use it to connect into the Ubuntu server over SSH.
- Your VM's IP address — find this by running `ip a` inside the VM and looking for the `inet` line under your network adapter (e.g. `192.168.x.x`)

## Steps

**1. Start the Server and login, then Open VS Code and SSH into the server**
In VS Code's terminal (or any terminal on your host machine):
```bash
ssh <username>@<vm-ip>
```
Replace `<username>` with your VM's login username and `<vm-ip>` with the IP address you found above. This gives you a command-line session running directly on the server. Your password if set on server will be required.

**2. Update the system**
```bash
sudo apt update && sudo apt upgrade -y
```
This refreshes the list of available packages and updates anything outdated, so you're installing software from a current, patched source.

**3. Install Nginx**
```bash
sudo apt install nginx -y
```
Nginx is the web server that will serve your site to browsers.

**4. Enable and start the service**
```bash
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx
```
`enable` makes Nginx start automatically every time the server boots. `start` runs it right now. `status` should show `active (running)` — confirm this before moving on.

**5. Add your site's content**
The site content is `index.html`, found in the `project-2-docker-compose` folder of this repo. Copy its contents, then on the server open a terminal then:
```bash
sudo nano index.html
```
Paste the copied content into the editor, save, and exit (`Ctrl+O`, then `Enter`, then `Ctrl+X`).

**6. Deploy the content to Nginx's document root**
```bash
sudo cp index.html /var/www/html/index.html
```
`/var/www/html` is the default folder Nginx serves files from — anything placed here becomes visible to anyone who visits your server's address.

**7. Verify it worked**
Find your VM's IP if you don't already have it:
```bash
ip a
```
Then open a browser on your **host machine** (not the VM) and visit:
```
http://<vm-ip>
```
You should see your site.

## Screenshot

![Deployed site](assets/deployed-site.png)