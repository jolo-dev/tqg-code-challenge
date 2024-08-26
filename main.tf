## Importing the state bucket. The key will be `tqg-terraform-state-bucket` and the value will be the name of the bucket.
resource "aws_s3_bucket" "state_bucket" {
  for_each = toset(["tqg-terraform-state-bucket"])
  bucket   = each.key
}

resource "aws_s3_bucket_public_access_block" "state_bucket_public_access_block" {
  for_each = toset(["tqg-terraform-state-bucket"])

  bucket = aws_s3_bucket.state_bucket[each.key].bucket
}

resource "aws_s3_bucket" "destination_bucket_name" {
  bucket = var.destination_bucket_name
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_lambda_function" "state_lambda" {
  filename      = "state-lambda.zip"
  function_name = "StateLambdaFunction"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "state-lambda.handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "nodejs20.x"

  environment {
    variables = {
      DESTINATION_BUCKET = var.destination_bucket_name
      DESTINATION_PREFIX = var.destination_prefix
    }
  }
}

resource "aws_lambda_permission" "allow_s3_trigger" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.state_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.state_bucket["tqg-terraform-state-bucket"].arn
}

resource "aws_s3_bucket_notification" "trigger_lambda" {
  bucket = aws_s3_bucket.state_bucket["tqg-terraform-state-bucket"].id

  lambda_function {
    lambda_function_arn = aws_lambda_function.state_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = var.source_prefix
  }

  depends_on = [
    aws_lambda_permission.allow_s3_trigger
  ]
}