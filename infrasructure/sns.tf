resource "aws_sns_topic" "scrape_notifications" {
  name = "PersonalAlert"
  tags = {
    project = var.project
    Name = var.app
  }
}

resource "aws_sns_topic_subscription" "scrape_notifications_target" {
  topic_arn = aws_sns_topic.scrape_notifications.arn
  protocol = "sms"
  endpoint = var.phone_number
}