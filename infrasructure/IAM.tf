resource "aws_iam_role" "scrape_vaccination_site" {
  name = "scrape_vaccination_site_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    project = var.project
    Name = var.app
  }
}

resource "aws_iam_policy" "ecs" {
  name = "ecs-vaccine-policy"
  description = "An ecs policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": [
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
          ],
          "Resource": "*"
      }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-attach" {
  role = aws_iam_role.scrape_vaccination_site.name
  policy_arn = aws_iam_policy.ecs.arn
}
