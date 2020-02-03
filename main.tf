resource "aws_sns_topic" "topic" {
    for_each = var.sns_topics
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
    }EOF

    tags = var.tags
}

resource "aws_sns_topic_subscription" "topic_subscription" {
    for_each  = var.sns_subscriptions

    topic_arn = aws_sns_topic.topic[each.value.topic_name].arn
    protocol  = each.value.protocol
    endpoint  = each.value.endpoint
}

resource "aws_sns_sms_preferences" "sms_preferences" {
    monthly_spend_limit = var.sns_sms_monthly_spend_limit
    default_sender_id   = var.sns_sms_sender_id
    default_sms_type    = var.sns_sms_type
}