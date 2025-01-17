variable "vm_web_name" {
  type        = string
  description = "The image name"
  default     = "netology-develop-platform-web"
}

variable "vm_db_name" {
  type        = string
  description = "The image name"
  default     = "netology-develop-platform-db"
}

variable "vm_web_instance_type" {
  type        = string
  description = "The type of instance"
  default     = "t2.micro"
}

variable "vm_web_instance_type_db" {
  type        = string
  description = "The type of instance"
  default     = "t3.small"
}

variable "vm_web_volume_type" {
  type        = string
  description = "The type disc"
  default     = "gp2"
}

variable "vm_web_owner" {
  type        = string
  description = "The type disc"
  default     = "SMMikh"
}

variable "vm_web_project" {
  type        = string
  description = "The type disc"
  default     = "hw_basics_working_terraform."
}

variable "vms_resources" {
  type = map(any)
  default = {
    web = {
      Platform = "Ubuntu"
      cores    = "1"
      memory   = "1G"
      hdd_size = "8G"
      hdd_type = "gp2"
    }
    db = {
      Platform = "Ubuntu"
      cores    = "2"
      memory   = "2G"
      hdd_size = "8G"
      hdd_type = "gp2"
    }
  }
}

variable "metadata" {
  type = map(any)
  default = {
    Owner    = "SMMikh"
    Project  = "hw_basics_working_terraform."
    Platform = "Ubuntu"
  }
}
