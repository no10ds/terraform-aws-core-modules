variable "public_subnet_ids_list" {
  type = list(string)
  description = "A list of public subnets from the VPC config"
}

variable "private_subnet_ids_list" {
  type = list(string)
  description = "A list of private subnets from each organisation network config"
}
