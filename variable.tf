variable "zone" {
    description = "Region for creating the resources"
    default = "ap-south-1"
}

variable "ak" {
    description = "Access key of IAM user"
    default = "AKIATXDVEGLBCQ4BMDQI"
}

variable "sk" {
    description = "Secret key of IAM user"
    default = "nZum0TmOlLzeYAooSXQWK+Ov/o4l+A7wh3WdTNCK"
}

variable "ami_id" {
    description = "OS image for the instance"
    default = "ami-08e5424edfe926b43"
}

variable "key" {
    description = "Keypair for the instance"
    default = "keypair"
}
