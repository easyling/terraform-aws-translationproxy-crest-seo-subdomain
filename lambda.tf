data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


data "archive_file" "prerender_headers" {
  type        = "zip"
  source_file = "${path.module}/prerender-headers.js"
  output_path = "${path.module}/prerender-headers.zip"
}
data "archive_file" "redirect_to_prerender" {
  type        = "zip"
  source_file = "${path.module}/redirect.js"
  output_path = "${path.module}/redirect.zip"
}

resource "aws_lambda_function" "prerender_headers" {
  filename      = "${path.module}/prerender-headers.zip"
  function_name = "${var.project}_set-prerender-headers"
  role          = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.prerender_headers.output_base64sha256

  runtime = "nodejs14.x"
  handler = "handler"
}

resource "aws_lambda_function" "prerender_redirect" {
  filename      = "${path.module}/redirect.zip"
  function_name = "${var.project}_redirect-to-prerender"
  role          = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.redirect_to_prerender.output_base64sha256

  runtime = "nodejs14.x"
  handler = "handler"
}
