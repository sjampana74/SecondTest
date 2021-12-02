
resource "aws_iam_user" "usera" {
  name = "readwrite"
  path = "/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "usera" {
  user = aws_iam_user.usera.name
}

resource "aws_iam_user_policy" "user_rw" {
  name = "testrw"
  user = aws_iam_user.usera.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole",
        "ec2:Describe*",
        "s3:ListObject",
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "userb" {
  name = "readonly"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_access_key" "userb" {
  user = aws_iam_user.userb.name
}

resource "aws_iam_user_policy" "user_ro" {
  name = "testro"
  user = aws_iam_user.userb.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sts:AssumeRole",
        "ec2:Describe*",
        "s3:ListObject",
        "s3:GetObject"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
