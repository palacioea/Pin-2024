variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "region" {
  description = "La región de AWS donde se desplegará el clúster"
  type        = string
  default     = "us-east-1"
}

variable "ec2_name" {
  description = "Nombre de la instancia EC2"
  type        = string
  default     = ""
}

variable "ec2_instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "ec2_key_name" {
  description = "Name of the key pair to connect to EC2"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = ""
}

variable "subnet_cidr" {
  description = "CIDR de la VPC"
  type        = string
  default     = ""
}
