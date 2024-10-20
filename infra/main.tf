# infra/main.tf

# -----------------------------
# IAM Role e Políticas para a Função Lambda
# -----------------------------

# Cria uma IAM Role que a função Lambda irá assumir
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Anexa a política básica de execução do Lambda à role
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# -----------------------------
# Função Lambda
# -----------------------------

resource "aws_lambda_function" "calc_function" {
  filename         = "../function.zip"  # Caminho para o arquivo zip da função Lambda
  function_name    = var.lambda_function_name
  handler          = "lambda_function.lambda_handler"  # Nome do arquivo e função handler
  runtime          = "python3.10"  # Python 3.10
  role             = aws_iam_role.lambda_exec_role.arn
  timeout          = 3  # Tempo máximo de execução em segundos

  source_code_hash = filebase64sha256("../function.zip")  # Garante que o código seja atualizado quando o zip mudar

  tags = {
    Name        = "PediAssistFunction"
    Environment = "Production"
  }
}

# -----------------------------
# API Gateway
# -----------------------------

# Cria a API REST
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API para o PediAssist Emergencial"
}

# Cria o recurso /calcular
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "calcular"
}

# Método POST para /calcular
resource "aws_api_gateway_method" "post_method_calcular" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Integra o método POST com a função Lambda usando integração proxy
resource "aws_api_gateway_integration" "post_integration_calcular" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.post_method_calcular.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.calc_function.invoke_arn
}

# Método OPTIONS para CORS
resource "aws_api_gateway_method" "options_method_calcular" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "options_integration_calcular" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.options_method_calcular.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# Resposta para o método OPTIONS (CORS)
resource "aws_api_gateway_method_response" "options_method_response_calcular" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.options_method_calcular.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Resposta de integração do método OPTIONS
resource "aws_api_gateway_integration_response" "options_integration_response_calcular" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.options_method_calcular.http_method
  status_code = aws_api_gateway_method_response.options_method_response_calcular.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  response_templates = {
    "application/json" = ""
  }
}


# Resposta para o método POST (CORS)
resource "aws_api_gateway_method_response" "post_method_response_calcular" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post_method_calcular.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }

  response_models = {
    "application/json" = "Empty"
  }
}

# Resposta de integração do método POST
resource "aws_api_gateway_integration_response" "post_integration_response_calcular" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post_method_calcular.http_method
  status_code = aws_api_gateway_method_response.post_method_response_calcular.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type'"
  }

  response_templates = {
    "application/json" = ""
  }
}

# -----------------------------
# Permissão para API Gateway invocar a Lambda
# -----------------------------
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.calc_function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# -----------------------------
# Implanta a API no estágio 'prod'
# -----------------------------

resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [
    aws_api_gateway_integration.post_integration_calcular,
    aws_api_gateway_integration.options_integration_calcular
  ]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
}

# -----------------------------
# Bucket S3 para o Frontend
# -----------------------------

# Cria o bucket S3 para hospedar o frontend
resource "aws_s3_bucket" "frontend" {
  bucket = var.s3_bucket_name  # Substitua por um nome de bucket único globalmente

  tags = {
    Name        = "PediAssistFrontend"
    Environment = "Production"
  }
}

# Configura as configurações de Block Public Access do bucket S3
resource "aws_s3_bucket_public_access_block" "frontend_public_access_block" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Define a política do bucket para permitir acesso público de leitura
resource "aws_s3_bucket_policy" "frontend_policy" {
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = ["${aws_s3_bucket.frontend.arn}/*"]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.frontend_public_access_block]
}

# Configuração de website para o bucket S3
resource "aws_s3_bucket_website_configuration" "frontend_website" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# -----------------------------
# Automatização do Upload do index.html
# -----------------------------

# Upload do index.html gerado para o bucket S3 usando aws_s3_object
resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.frontend.bucket
  key          = "index.html"
  content      = templatefile("${path.module}/../frontend/index.html.tmpl", {
    apiEndpoint = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.aws_region}.amazonaws.com/prod"
  })
  content_type = "text/html"

  depends_on = [
    aws_api_gateway_deployment.deployment,
    aws_s3_bucket_public_access_block.frontend_public_access_block,
    aws_s3_bucket_policy.frontend_policy
  ]
}