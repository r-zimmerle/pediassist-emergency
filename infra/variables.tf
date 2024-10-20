# infra/variables.tf

variable "aws_region" {
  description = "Região da AWS para deploy dos recursos"
  type        = string
  default     = "us-east-1"  # Substitua pela região desejada, se necessário
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "pediassist_emergencial_function"
}

variable "api_name" {
  description = "Nome da API Gateway"
  type        = string
  default     = "PediAssistAPI"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 para hospedar o frontend (deve ser único globalmente)"
  type        = string
  default     = "pediassist-frontend-bucket-unique-name"  # Substitua por um nome único
}
