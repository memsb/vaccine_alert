resource "aws_cloudwatch_event_rule" "poll_vaccination_age" {
  name = "poll_vaccination_age"
  description = "Check minimum vaccination age"
  schedule_expression = "rate(6 hours)"
  tags = {
    project = var.project
    Name = var.app
  }
}

resource "aws_iam_role" "ecs_events" {
  name = "ecs_vaccine_events"

  assume_role_policy = <<DOC
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
DOC
}

resource "aws_iam_role_policy" "ecs_events_run_task_with_any_role" {
  name = "ecs_vaccine_events_run_task_with_any_role"
  role = aws_iam_role.ecs_events.id

  policy = <<DOC
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "ecs:RunTask",
            "Resource": "${replace(aws_ecs_task_definition.scraper.arn, "/:\\d+$/", ":*")}"
        }
    ]
}
DOC
}

resource "aws_cloudwatch_event_target" "fargate_task_target" {
  target_id = "scrape_vaccination_site"
  rule = aws_cloudwatch_event_rule.poll_vaccination_age.name
  arn = aws_ecs_cluster.vaccination_site_cluster.arn
  role_arn = aws_iam_role.ecs_events.arn

  ecs_target {
    group = "family:vaccination_alert"
    task_definition_arn = aws_ecs_task_definition.scraper.arn
    launch_type = "FARGATE"
    network_configuration {
      assign_public_ip = true
      subnets = [
        "subnet-073ade7c"
      ]
      security_groups = [
        "sg-094d48c440a8f87e9"
      ]
    }
  }

}