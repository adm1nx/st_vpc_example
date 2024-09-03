variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDRs"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDRs"
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a", "us-east-1b"]
}

variable "web_server_count" {
  type = number
  description = "Number of web servers to create"
  default = 2
}

variable "public_key" {
  type = string
  description = "Public SSH key"
}