variable "sns_region" {
    description = "The region of SNS service."
    type        = string
}

variable "sns_topics" {
    description = "The list of SNS topics name to create."
    type        = list(string)
    default     = []
}

variable "sns_sms_subscriptions" {
    description = "SMS subscriptions associated with topics previously created. Type: map(sms -> topic ARN)"
    type        = map
    default     = {}
}

variable "sns_email_subscriptions" {
    description = "EMail subscriptions associated with topics previously created. Type: map(email -> topic ARN)"
    type        = map
    default     = {}
}

variable "sns_sms_monthly_spend_limit" {
    description = "The maximum amount in USD that you are willing to spend each month to send SMS messages."
    type        = number
    default     = 1
}

variable "sns_sms_sender_id" {
    description = "A string, such as your business brand, that is displayed as the sender on the receiving device."
    type        = string
    default     = ""
}

variable "sns_sms_type" {
    description = "The type of SMS message that you will send by default. Possible values are: Promotional, Transactional"
    type        = string
    default     = "Promotional"
}

variable "tags" {
    description = "Tags to associate to SNS topics"
    type        = map
    default     = {}
}