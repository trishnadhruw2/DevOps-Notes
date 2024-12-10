variable "AWS_REGION" {
    default = "ap-south-1"
}
variable "AWS_AMI" {
    default = "ami-0614680123427b75e"
}
variable "akey" {
    default = "a"
}
variable "skey" {
    default = "s"
}
variable "user_names" {
  description = "Create IAM users with these names"
  type        = list(string)
  default     = ["neo", "trinity", "morpheus"]
}
