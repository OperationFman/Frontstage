variable "iam_role" {
  default = "backstage-role"
  type    = string
}


variable "ecr_repo" {
  default = "backstage-ecr"
  type    = string
}
