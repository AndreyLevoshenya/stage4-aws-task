# policies

resource "aws_iam_policy" "full_access_policy_ec2" {
  name        = "FullAccessPolicyEC2"
  description = "Allows full access to all EC2 resources"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ec2:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "full_access_policy_s3" {
  name        = "FullAccessPolicyS3"
  description = "Allows full access to all S3 buckets"
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

resource "aws_iam_policy" "read_access_policy_s3" {
  name        = "ReadAccessPolicyS3"
  description = "Allows read-only access (GET and LIST) to all S3 buckets"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = "*"
      }
    ]
  })
}

# roles

resource "aws_iam_role" "full_access_role_ec2" {
  name = "FullAccessRoleEC2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "full_access_ec2_role_attach" {
  policy_arn = aws_iam_policy.full_access_policy_ec2.arn
  role       = aws_iam_role.full_access_role_ec2.name
}

resource "aws_iam_role" "full_access_role_s3" {
  name = "FullAccessRoleS3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "full_access_s3_role_attach" {
  policy_arn = aws_iam_policy.full_access_policy_s3.arn
  role       = aws_iam_role.full_access_role_s3.name
}

resource "aws_iam_role" "read_access_role_s3" {
  name = "ReadAccessRoleS3"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "read_access_s3_role_attach" {
  policy_arn = aws_iam_policy.read_access_policy_s3.arn
  role       = aws_iam_role.read_access_role_s3.name
}

# groups

resource "aws_iam_group" "full_access_group_ec2" {
  name = "FullAccessGroupEC2"
}

resource "aws_iam_group_policy_attachment" "full_access_ec2_group_attach" {
  group      = aws_iam_group.full_access_group_ec2.name
  policy_arn = aws_iam_policy.full_access_policy_ec2.arn
}

resource "aws_iam_group" "full_access_group_s3" {
  name = "FullAccessGroupS3"
}

resource "aws_iam_group_policy_attachment" "full_access_s3_group_attach" {
  group      = aws_iam_group.full_access_group_s3.name
  policy_arn = aws_iam_policy.full_access_policy_s3.arn
}

resource "aws_iam_group" "read_access_group_s3" {
  name = "ReadAccessGroupS3"
}

resource "aws_iam_group_policy_attachment" "read_access_s3_group_attach" {
  group      = aws_iam_group.read_access_group_s3.name
  policy_arn = aws_iam_policy.read_access_policy_s3.arn
}

# users

resource "aws_iam_user" "ec2-user" {
  name = "EC2User"
}

resource "aws_iam_user_group_membership" "ec2-user-group" {
  user = aws_iam_user.ec2-user.name
  groups = [
    aws_iam_group.full_access_group_ec2.name
  ]
}

resource "aws_iam_user" "s3-user" {
  name = "S3User"
}

resource "aws_iam_user_group_membership" "s3-user-group" {
  user = aws_iam_user.s3-user.name
  groups = [
    aws_iam_group.full_access_group_s3.name
  ]
}

resource "aws_iam_user" "s3-user-read" {
  name = "S3UserRead"
}

resource "aws_iam_user_group_membership" "s3-user-read-group" {
  user = aws_iam_user.s3-user-read.name
  groups = [
    aws_iam_group.read_access_group_s3.name
  ]
}