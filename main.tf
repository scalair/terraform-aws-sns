data "aws_region" "current" {}

resource "aws_sns_topic" "topic" {
    for_each = toset(var.sns_topics)
    name = each.key
    display_name = each.key
    delivery_policy = <<FILE
{
    "http": {
        "defaultHealthyRetryPolicy": {
            "minDelayTarget": 20,
            "maxDelayTarget": 20,
            "numRetries": 3,
            "numMaxDelayRetries": 0,
            "numNoDelayRetries": 0,
            "numMinDelayRetries": 0,
            "backoffFunction": "linear"
        },
        "disableSubscriptionOverrides": false,
        "defaultThrottlePolicy": {
            "maxReceivesPerSecond": 1
        }
    }
}
FILE

    tags = var.tags
}

locals {
  sms_subs = flatten([
    for sub in var.sns_subscriptions: [
      for endpoint in split(",", sub.endpoints): {
        endpoint = endpoint
        topic    = sub.topic
      }
    ] if sub.type == "sms"
  ])

  email_subs = flatten([
    for sub in var.sns_subscriptions: [
      for endpoint in split(",", sub.endpoints): {
        endpoint = endpoint
        topic    = sub.topic
      }
    ] if sub.type == "email"
  ])
}

resource "aws_sns_topic_subscription" "topic_sms_subscription" {
    for_each = {
      for sub in local.sms_subs : sub.endpoint => sub.topic
    }

    topic_arn = aws_sns_topic.topic[each.value].arn
    protocol  = "sms"
    endpoint  = each.key
}

resource "null_resource" "topic_email_subscription" {
    for_each = {
      for sub in local.email_subs : "${sub.endpoint}-${sub.topic}" => sub
    }

    provisioner "local-exec" {
        command = <<COMMAND
AWS_DEFAULT_REGION=${data.aws_region.current.name}
aws sns subscribe --topic-arn ${aws_sns_topic.topic[each.value.topic].arn} --protocol email --notification-endpoint ${each.value.endpoint}
COMMAND
    }
}

resource "aws_sns_sms_preferences" "sms_preferences" {
    default_sender_id   = var.sns_sms_preferences_sender_id
    default_sms_type    = var.sns_sms_preferences_type
}
