variable "region" {
  description = "The AWS region to deploy in"
  type        = string
}

variable "agent_server_count" {
  description = "The number of agent servers"
  type        = number
  default     = 1
}

variable "agent_server_size" {
  description = "The size of agent servers"
  type        = string
  default     = "t3.medium"
}

variable "other_server_size" {
  description = "The size of other servers (DB, Guac, Web)"
  type        = string
  default     = "t3.medium"
}

variable "agent_server_disk_size" {
  description = "The disk size of agent servers in GB"
  type        = number
  default     = 50
}

variable "other_server_disk_size" {
  description = "The disk size of other servers (DB, Guac, Web) in GB"
  type        = number
  default     = 50
}

variable "custom_ami" {
  description = "Custom AMI ID if region-specific AMI is not available"
  type        = string
  default     = ""
}
