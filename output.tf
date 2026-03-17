output "app_url" {
  value       = "http://${aws_instance.app.public_ip}:${var.app_port}"
  description = "Open this URL in browser"
}
