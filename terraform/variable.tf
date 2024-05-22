 ########## VPC Subnet Variables ######################
# 1. Bastion Subnets
variable "public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR Values for Bastion"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# 2. app Subnets
variable "app_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR Values for APP & DB"
  default     = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
}

# 3. DB Subnets
variable "db_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR Values for DB"
  default     = ["10.0.111.0/24", "10.0.112.0/24", "10.0.113.0/24"]
}

# 4. Available Zone
variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["ap-northeast-2a", "ap-northeast-2c", "ap-northeast-2d"] //서울
}

# 5. Region
variable "region" { 
  description = "AWS region" 
  type        = string 
  default     = "ap-northeast-2"  //서울
}


#### db #####
variable "db_user_name" { 
  description = "Database User Name" 
  type        = string
  default     = "nana"
  sensitive = true
}
variable "db_user_pass" { 
  description = "Database User Password" 
  type        = string 
  default     = "nana1234"
  sensitive = true
}

######################## Key Variables ########################
variable "key_name" {
  description = "Name of the key pair"
  type        = string
  default     = "donkey-keypair"
  sensitive = true
}

variable "public_key_location" {
  description = "Location of the Public key"
  type        = string
  default     = "./donkey-keypair.pub"
  sensitive = true
}
