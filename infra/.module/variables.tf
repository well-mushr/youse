variable "application_name" {
  description = "The name of the application"
}

variable "force_destroy" {
  default     = false
  description = "Force destroy"
  type        = bool
}

variable "prefix" {
  description = "Prefix to user on variable name"
}

variable "versioning" {
  default = true
  description = "Turn on versioning"
}

variable "expiration_days" {
  default = 180
  description = " Specifies a period in the object's expire" 
}

variable "kms_master_key_id" {
  description = "This key is used to encrypt bucket objects"
}

variable "user_id" {
  description = "User if with FULL acess"
}