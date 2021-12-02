#To create a lambda function 
#To create a role and attach policy
#To create a S3 trigger for event notifications that depends on the proper permissions on Bucket A

resource "aws_iam_role" "iam_lambda" {
  name = "iam_role_for_lambda"
  path = "/"
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

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-s3-policy"
  description = "An s3 policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "logs:*"
      ],
      "Resource": "arn:aws:logs:*:*:*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.gtestbucketa.arn}",
        "${aws_s3_bucket.gtestbucketa.arn}/*",
        "${aws_s3_bucket.gtestbucketb.arn}",
        "${aws_s3_bucket.gtestbucketb.arn}/*"
      ]
    }
  ]
} 
    EOF
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = "${aws_iam_role.iam_lambda.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

resource "aws_lambda_function" "uploadtobucket" {
  filename = "uploadtobucket.zip"
  function_name = "copytobucket"

  source_code_hash = filebase64sha256("uploadtobucket.zip")

  handler = "copytobucket.lambda_handler"
  runtime = "python3.6"

  timeout = 30
  memory_size = 2048 #for big images

  role = aws_iam_role.iam_lambda.arn

  environment {
    variables = {
      DESTINATION_BUCKET = "${aws_s3_bucket.gtestbucketb.id}"
    }
  }
}


resource "aws_s3_bucket_notification" "s3-trigger" {
    bucket = "${aws_s3_bucket.gtestbucketa.id}"

    lambda_function {
        lambda_function_arn = "${aws_lambda_function.uploadtobucket.arn}"
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".jpg"
    }

    depends_on = [aws_lambda_permission.s3]
}


resource "aws_lambda_permission" "s3" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.uploadtobucket.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.gtestbucketa.arn}"
}

