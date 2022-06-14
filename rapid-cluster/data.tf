#data "terraform_remote_state" "platform" {
#  backend   = "s3"
#  workspace = "prod"
#  config = {
#    bucket = "ten-ds-tfstate"
#    key    = "platform/terraform.tfstate"
#    region = "eu-west-2"
#  }
#}

data "aws_caller_identity" "current" {}

locals {
  region      = "eu-west-2"
  account_id  = data.aws_caller_identity.current.account_id
  domain_name = "rapid.ten.dataops.cabinetoffice.gov.uk"
}