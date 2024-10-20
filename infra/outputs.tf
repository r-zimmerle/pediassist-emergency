# outputs.tf

output "api_endpoint" {
  value       = "${aws_api_gateway_deployment.deployment.invoke_url}"
  description = "Endpoint da API do PediAssist Emergencial"
}

output "s3_website_url" {
  value       = "http://${aws_s3_bucket.frontend.bucket}.s3-website-${var.aws_region}.amazonaws.com"
  description = "URL do site hospedado no S3"
}
