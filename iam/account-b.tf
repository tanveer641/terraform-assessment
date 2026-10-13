data "aws_iam_policy_document" "roleC_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account_a_id}:role/roleB"
      ]
    }
  }
}

resource "aws_iam_role" "roleC" {
  provider = aws.account_b

  name               = "roleC"
  assume_role_policy = data.aws_iam_policy_document.roleC_trust.json
}

resource "aws_iam_role_policy" "roleC_s3" {
  provider = aws.account_b

  name = "roleC-s3-access"
  role = aws_iam_role.roleC.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "BucketLevelAccess"
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}"
      },
      {
        Sid      = "ObjectLevelAccess"
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      }
    ]
  })
}
