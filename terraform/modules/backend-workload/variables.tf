variable "image" {
  type = string
}

variable "host" {
  type = string
}

variable "env" {
  type        = string
  description = "Environment name (dev, staging, production)"
}
