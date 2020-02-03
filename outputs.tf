output "sns_topics" {
  value = aws_sns_topic.topic
}

output "sns_subscriptions" {
  value = aws_sns_topic_subscription.subscription
}

