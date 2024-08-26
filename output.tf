output "destination_bucket_name" {
  value = aws_s3_bucket.destination_bucket_name.bucket
}

output "lambda_function_name" {
  value = aws_lambda_function.state_lambda.function_name
}