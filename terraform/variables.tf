variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 instance type for the Jenkins/SonarQube/Tomcat server"
  type        = string
  default     = "m7i-flex.large"   # Jenkins + SonarQube + Tomcat need >= 4GB RAM; t3.large recommended
}

variable "key_pair_name" {
  description = "Name of an EXISTING EC2 key pair (create it in AWS console/CLI first)"
  type        = string
  default = "Devops"
}

variable "vpc_id" {
  description = "VPC ID to launch the instance into (leave blank to use default VPC)"
  type        = string
  default     = ""
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance into (leave blank to use default subnet)"
  type        = string
  default     = ""
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the server (use your own IP/32 in production)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "instance ami_id for installing linux server"
  type = string
  default = "ami-01a18c38ece67e620"
  
}

variable "root_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Project     = "JavaApp-CICD"
    ManagedBy   = "Terraform"
    Environment = "demo"
  }
}
