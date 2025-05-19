output "instance_public_ip" {
  value = aws_instance.web.public_ip
}
# Output the private key for secure storage in GitHub Secrets
output "private_key" {
  value     = tls_private_key.generated.private_key_pem
  sensitive = true
}
