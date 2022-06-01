resource "aws_iam_role" "lambda_role" {
  name = "Test_Lambda_role"
  assume_role_policy = file("./assume_policy.json")
}

resource "aws_iam_policy" "lambda_iam_policy" {
  name = "Test_lambda_iam_policy"
  policy = file("./policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_attach_policy" {
  policy_arn = aws_iam_policy.lambda_iam_policy.arn
  role = aws_iam_role.lambda_role.name
}

data "archive_file" "zip_py_code" {
  source_dir = "./"
  output_path = "./hello-python.zip"
  type = "zip"
}

resource "aws_lambda_function" "tf_lambda_function" {
  function_name = "Test_Lambda"
  role = aws_iam_role.lambda_role.arn
  filename = "./hello-python.zip"
  handler = "index.lambda_handler"
  runtime = "python3.8"
  depends_on = [aws_iam_role_policy_attachment.lambda_attach_policy]
}