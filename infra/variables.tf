# infra/variables.tf

variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados"
  default     = "us-east-1"  # Substitua pela região desejada
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  default     = "pediassist_emergencial_function"
}

variable "api_name" {
  description = "Nome da API Gateway"
  default     = "PediAssistAPI"
}

variable "s3_bucket_name" {
  description = "Nome único do bucket S3 para o frontend"
  default     = "pediassist-frontend-bucket-unique-name"  # Certifique-se de que seja único globalmente
}
