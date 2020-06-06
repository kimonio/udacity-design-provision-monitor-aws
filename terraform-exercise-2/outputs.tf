# Define the output variable for the lambda function.
output "lambda_arn" {
    value = aws_lambda_function.greet_lambda.arn
}

output "lambda_source_code_hash" {
    value = aws_lambda_function.greet_lambda.source_code_hash
}

output "lambda_source_code_size" {
    value = aws_lambda_function.greet_lambda.source_code_size
}