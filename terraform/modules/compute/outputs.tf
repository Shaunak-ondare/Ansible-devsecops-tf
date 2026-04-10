output "linux_public_ip" {
  value = aws_instance.linux_host.public_ip
}

output "windows_public_ip" {
  value = aws_instance.windows_host.public_ip
}
