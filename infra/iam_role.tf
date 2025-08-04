# Creating an IAM Role for Redshift
resource "aws_iam_role" "redshift_role" {
  name = "redshift_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "s3_full_access_policy" {
  name        = "s3_full_access_policy"
  description = "all actions on S3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attched_policy" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = aws_iam_policy.s3_full_access_policy.arn
}