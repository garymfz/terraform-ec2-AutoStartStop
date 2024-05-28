variable "accountname" {
  description = "Name of the account in which is deployed"
  type        = string
}
variable "region" {
  description = "name of the region"
  type        = string
}

variable "cronstart" {
  description = "start time of ec2"
  type        = string
}
variable "cronstop" {
  description = "stop time of ec2"
  type        = string
}

variable "supertag" {
  description = "tag for ec2 value"
  type        = string
}