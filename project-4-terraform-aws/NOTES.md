## Secrets and local-only files

This project needs a `terraform.tfvars` file with your own values — it is
**not** included in this repo (see `.gitignore`). To set it up:

1. Copy the template:
```bash
   cp terraform.tfvars.example terraform.tfvars
```
2. Fill in:
   - `key_name` — any name you want for your AWS key pair
   - `my_ip` — your public IP address in CIDR format. Get it with:
```bash
     curl ifconfig.me
```
     then append `/32` (e.g. `x.x.x.x/32`)

You'll also need:
- An AWS account with an IAM user configured locally (`aws configure`)
- Your own SSH public key registered on the machine running Terraform
  (see Project 2's NOTES.md for generating one)
- Docker Hub and GitHub Actions secrets set up as described in Project 3's NOTES.md, if you're extending the CI/CD pipeline to deploy here