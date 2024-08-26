variable "region" {
  description = "AWS region"
  default     = "eu-central-1"
}

variable "destination_bucket_name" {
  description = "Destination Name of the S3 bucket"
  type = string
  default = "tqg-terraform-state-destination-bucket"
}

variable "source_prefix" {
  description = "value for source_prefix"
  type = string
  default = "foo"
}

variable "destination_prefix" {
  description = "value for destination_prefix"
  type = string
  default = "bar"
}
