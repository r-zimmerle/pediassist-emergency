# infra/providers.tf

provider "aws" {
  region = var.aws_region  # Utiliza a variável definida em variables.tf
}
