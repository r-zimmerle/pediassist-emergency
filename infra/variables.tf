variable "aws_region" {
  default = "us-east-1"  # Substitua pela região desejada
}

variable "lambda_function_name" {
  default = "pediassist_emergencial_function"
}

variable "api_name" {
  default = "PediAssistAPI"
}

variable "s3_bucket_name" {
  default = "pediassist-frontend-bucket-unique-name"  # Certifique-se de que seja único globalmente
}
