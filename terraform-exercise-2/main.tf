# Designate a cloud provider, region, and credentials
# Credentials are stored locally at ~/.aws/credentials
provider "aws" {
  region  = var.region
  profile = "udacity"
}

# Zip up the lambda code
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "/tmp/lambda.zip"
  source {
    content  = file("greet_lambda.py")
    filename = "greet_lambda.py"
  }
}

# Create an IAM role for the lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attach policy to the lambda role to allow it to deploy to a VPC
data "aws_iam_policy" "lambda_vpc_access" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = data.aws_iam_policy.lambda_vpc_access.arn
}

# Lambda function
resource "aws_lambda_function" "greet_lambda" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "greet_lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "greet_lambda.lambda_handler"
  runtime          = "python2.7"
  vpc_config {
    subnet_ids         = ["subnet-0becb32eb662674dd", "subnet-0bed00fc00ffd2477"]
    security_group_ids = ["sg-021342e9836e7a739"]
  }
  environment {
    variables = {
      greeting = "Hello"
    }
  }
}
