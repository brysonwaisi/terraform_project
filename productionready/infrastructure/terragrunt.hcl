remote_state {
  backend = "s3"
  generate = {
    path      = "state.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    # profile = "breezy"
    role_arn = "arn:aws:iam::398094181254:role/terraform"
    bucket = "metamore-terraform-state"

    key = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock-table"
  }
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
provider "aws" {
  region  = "us-east-1"
  # profile = "breezy" -- depends
  
  assume_role {
    # session_name = "metamore" -optional
    role_arn = "arn:aws:iam::398094181254:role/terraform"
  }
}
EOF
}