variable "sns_topics" {
    description = "The list of SNS topics name to create."
    type        = list(string)
    default     = []
}

variable "sns_subscriptions" {
    description = "The list of SNS subscriptions associated with topics previously created."
    type        = list(object({
        topic_name = string
        protocol   = string // Terraform does not yet support email protocol
        emdpoint   = string
    }))
    default     = []
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
    default     = Promotional
}

variable "tags" {
    description = "Tags to associate to SNS topics"
    type        = map
    default     = {}
}