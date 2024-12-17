variable "aws_account_id" {
  description = "AWS account ID"
  type = string
}

variable "user_pool_id" {
  description = "ID do user pool"
  type        = string
  default     = "us-east-1_QFaugCzHu"
}

variable "up_client_id" {
  description = "ID do client do user pool"
  type        = string
  default     = "4j7fhutokfne6ad9mv5it0d4d7"
}
