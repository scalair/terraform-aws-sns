provider "aws" {
  region = var.sns_region
}

resource "aws_sns_topic" "topic" {
    for_each = toset(var.sns_topics)
    name = each.key
    display_name = each.key
    delivery_policy = <<EOF
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
EOF

    tags = var.tags
}

locals {
  sms_subs = flatten([
    for nums, topic in var.sns_sms_subscriptions: [
      for num in split(",", nums): {
        num   = num
        topic = topic
      }
    ]
  ])
}

resource "aws_sns_topic_subscription" "topic_sms_subscription" {
    for_each = {
        for sub in local.sms_subs : sub.num => sub.topic
    }

    topic_arn = aws_sns_topic.topic[each.value].arn
    protocol  = "sms"
    endpoint  = each.key
}

resource "null_resource" "topic_email_subscription" {
    for_each  = var.sns_email_subscriptions

    provisioner "local-exec" {
        command = <<COMMAND
AWS_DEFAULT_REGION=${var.sns_region}
aws sns subscribe --topic-arn ${aws_sns_topic.topic[each.value].arn} --protocol email --notification-endpoint ${each.key}
COMMAND
    }
}

resource "aws_sns_sms_preferences" "sms_preferences" {
    monthly_spend_limit = var.sns_sms_monthly_spend_limit
    default_sender_id   = var.sns_sms_sender_id
    default_sms_type    = var.sns_sms_type
}
