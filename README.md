# Terraform AWS SNS

Create SNS topics and subscriptions.

Here an example Terragrunt configuration:

```hcl
inputs = {

  sns_topics = [
    "topic1",
    "topic2"
  ]
  
  sns_subscriptions = [
    {
      endpoints  = "+33600000000",
      topic      = "topic1",
      type       = "sms"
    },
    {
      endpoints  = "admin@example.com,tech@example.com",
      topic      = "topic2"
      type       = "email"
    },
    {
      endpoints  = "+33689674523,+33712345678",
      topic      = "topic1"
      type       = "sms"
    }
  ]

  sns_sms_preferences_sender_id = "Notification"
  sns_sms_preferences_type      = "Transactional"

  tags = {
    env = "prod"
  }
}
```
