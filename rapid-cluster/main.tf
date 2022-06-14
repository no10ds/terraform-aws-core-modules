module "app_cluster" {
  # source = "git@github.com:no10ds/rapid-infrastructure.git//modules/app-cluster?ref=1c44ef9aaad8e037279c0972772174c5c246c59a"
  source                                          = "./app-cluster"
  app-replica-count-desired                       = 1
  app-replica-count-max                           = 2
  resource-name-prefix                            = "ten-ds-rapid"
  application_version                             = "v1.2.0"
  support_emails_for_cloudwatch_alerts            = ["lcard@no10.gov.uk"]
  cognito_user_login_app_credentials_secrets_name = module.auth.cognito_user_app_secret_manager_name
  cognito_user_pool_id                            = module.auth.cognito_user_pool_id
  domain_name                                     = local.domain_name
  rapid_ecr_url                                   = "public.ecr.aws/no10-rapid/api"
  certificate_validation_arn                      = "arn:aws:acm:eu-west-2:745078845594:certificate/fa7e10a5-fd6d-4f2e-aafb-8f3dd0a90bdc"
  hosted_zone_id                                  = "Z0455601XJQCXJ68BL94"
  aws_account                                     = local.account_id
  aws_region                                      = local.region
  data_s3_bucket_arn                              = aws_s3_bucket.this.arn
  data_s3_bucket_name                             = aws_s3_bucket.this.id
  log_bucket_name                                 = data.terraform_remote_state.platform.outputs.log_bucket
  vpc_id                                          = data.terraform_remote_state.platform.outputs.vpc_id
  public_subnet_ids_list                          = data.terraform_remote_state.platform.outputs.public_subnets
  private_subnet_ids_list                         = data.terraform_remote_state.platform.outputs.private_subnets
#  parameter_store_variable_arns                   = [module.auth.protected_scopes_parameter_store_arn]
  athena_query_output_bucket_arn                  = module.data_workflow.athena_query_result_output_bucket_arn
  ip_whitelist = [
    "80.43.78.21/32",     # Lewis Home
    "165.225.80.0/22",    #No10
    "147.161.166.0/23",   #No10
    "165.225.196.0/23",   #No10
    "165.225.198.0/23",   #No10
    "81.144.180.0/24",    #No10 desktop
    "165.225.17.0/24",    #No10 desktop
    "147.161.236.0/23",   #No 10
    "52.56.62.0/24",      #Home Office
    "51.149.8.0/25",      # Cabinet Office
    "35.178.62.180/32",   # PaaS
    "18.130.41.69/32",    # PaaS
    "35.177.73.214/32",   # PaaS
    "82.15.222.149/32",   # PHE
    "5.81.201.119/32",    # PHE
    "136.228.244.0/24",   # DHSC
    "90.255.158.45/32",   # DHSC
    "136.228.225.151/32", #DHSC
    "212.250.43.0/24",    # DHSC
    "136.228.233.0/24",   # DHSC
    "136.228.224.0/24",   # DHSC
    "185.251.10.0/24",    # DHSC
    "185.251.11.0/24",    # DHSC
    "194.33.196.0/24",    # MoJ
    "194.33.192.0/24",    # MoJ
  ]
}


module "auth" {
  # source               = "git@github.com:no10ds/rapid-infrastructure.git//modules/auth?ref=1c44ef9aaad8e037279c0972772174c5c246c59a"
  source               = "./auth"
  tags                 = {}
  domain_name          = local.domain_name
  resource-name-prefix = "ten-ds-rapid"
}


module "data_workflow" {
  # source = "git@github.com:no10ds/rapid-infrastructure.git//modules/data-workflow?ref=1c44ef9aaad8e037279c0972772174c5c246c59a"
  source               = "./data-workflow"
  resource-name-prefix = "ten-ds-rapid"
  aws_account          = local.account_id
  data_s3_bucket_arn   = aws_s3_bucket.this.arn
  data_s3_bucket_name  = aws_s3_bucket.this.id
  vpc_id               = data.terraform_remote_state.platform.outputs.vpc_id
  private_subnet       = data.terraform_remote_state.platform.outputs.private_subnets[0]
  aws_region           = local.region
}


resource "aws_s3_bucket" "this" {
  # checkov:skip=CKV_AWS_144:No need for cross region replication
  bucket = "ten-ds-rapid"

}

#resource "aws_s3_bucket_public_access_block" "this" {
#  bucket = aws_s3_bucket.this.id
#
#  ignore_public_acls      = true
#  block_public_acls       = true
#  block_public_policy     = true
#  restrict_public_buckets = true
#
#}