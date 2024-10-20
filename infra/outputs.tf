# infra/outputs.tf

output "api_endpoint" {
  description = "Endpoint da API Gateway"
  value       = aws_api_gateway_deployment.deployment.invoke_url
}

output "s3_website_url" {
  description = "URL do website hospedado no S3"
  value       = aws_s3_bucket.frontend.bucket_regional_domain_name
}
