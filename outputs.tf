output "sns_topics" {
  value = aws_sns_topic.topic
}

output "sns_sms_subscriptions" {
  value = aws_sns_topic_subscription.topic_sms_subscription
}

output "sns_email_subscriptions" {
  value = null_resource.topic_email_subscription
}