variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Default region"
  type        = string
  default     = "europe-west8"
}

variable "zone" {
  description = "Default zone"
  type        = string
  default     = "europe-west8-b"
}

variable "network_cidr" {
  description = "CIDR for VPC subnet"
  type        = string
  default     = "10.10.0.0/24"
}
