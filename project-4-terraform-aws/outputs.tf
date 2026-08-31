output "instance_public_ip" {
  description = "The Elastic IP address of the web server"
  value       = aws_eip.web_eip.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh ec2-user@${aws_eip.web_eip.public_ip}"
}

output "github_actions_access_key_id" {
  value = aws_iam_access_key.github_actions_key.id
}

output "github_actions_secret_access_key" {
  value     = aws_iam_access_key.github_actions_key.secret
  sensitive = true
}