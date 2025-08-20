terraform {
  backend "s3" {
    bucket       = "frontstage-backstage-stage"
    key          = "terraform.tfstate"
    region       = "ap-southeast-2"
    encrypt      = true
    use_lockfile = true
  }
}
