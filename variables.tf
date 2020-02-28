variable "sns_region" {
    description = "The region of SNS service."
    type        = string
}

variable "sns_topics" {
    description = "The list of SNS topics name to create."
    type        = list(string)
    default     = []
}

variable "sns_subscriptions" {
    description = "Subscriptions associated with topics previously created."
    type        = list(object({
      endpoints  = string, // comma separated values
      topic      = string,
      type       = string
    }))
    default = []
}

variable "sns_sms_preferences_sender_id" {
    description = "A string, such as your business brand, that is displayed as the sender on the receiving device. Must be at most 11 characters."
    type        = string
    default     = ""
}

variable "sns_sms_preferences_type" {
    description = "The type of SMS message that you will send by default. Possible values are: Promotional, Transactional"
    type        = string
    default     = "Promotional"
}

variable "tags" {
    description = "Tags to associate to SNS topics"
    type        = map
    default     = {}
}