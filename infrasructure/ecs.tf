resource "aws_ecs_cluster" "vaccination_site_cluster" {
  name = "vaccination-site-cluster"
  capacity_providers = [
    "FARGATE"]

  setting {
    name = "containerInsights"
    value = "enabled"
  }

  tags = {
    project = var.project
    Name = var.app
  }
}

resource "aws_ecr_repository" "vaccination_site_repository" {
  name = "vaccination_alert"
  image_tag_mutability = "MUTABLE"
  tags = {
    project = var.project
    Name = var.app
  }
}

resource "aws_ecs_task_definition" "scraper" {
  family = "vaccination_alert"
  execution_role_arn = aws_iam_role.scrape_vaccination_site.arn
  task_role_arn = aws_iam_role.scrape_vaccination_site.arn
  requires_compatibilities = [
    "FARGATE"]
  cpu = 256
  memory = 512
  network_mode = "awsvpc"

  container_definitions = jsonencode([
    {
      name = "vaccination_alert"
      image = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com/vaccination_alert:latest"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group = "/ecs/vaccination_alert"
          awslogs-region = "eu-west-2"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    project = var.project
    Name = var.app
  }
}