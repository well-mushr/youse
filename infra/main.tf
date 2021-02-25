/**
 * EDIT ENVIRONMENT NAME HERE
 */
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "youse"
    key    = "challenge/infra.tfstate"
    region = "us-east-2"
  }
}

/**
 * NO NEED TO EDIT BELOW THIS POINT, UNLESS INSTANCE SIZE
 * CHANGE IS REQUIRED
 */

data "local_file" "config" {
  filename = "${path.module}/../config.json"
}

locals {
  config = jsondecode(data.local_file.config.content)
}

provider "aws" {
  region = local.config["region"]
}

data "aws_canonical_user_id" "current_user" {}

resource "aws_kms_key" "weekly" {
  description = "This key is used to encrypt bucket objects"
}

module "provision_weekly" {
  source            = "./.module"
  application_name  = local.config["application_name"]
  prefix            = "weekly"
  versioning        = true
  kms_master_key_id = aws_kms_key.weekly.arn
  user_id           = data.aws_canonical_user_id.current_user.id
  expiration_days   = 60
}

resource "aws_kms_key" "daily" {
  description = "This key is used to encrypt bucket objects"
}

module "provision_daily" {
  source            = "./.module"
  application_name  = local.config["application_name"]
  prefix            = "daily"
  versioning        = true
  kms_master_key_id = aws_kms_key.daily.arn
  user_id           = data.aws_canonical_user_id.current_user.id
  expiration_days   = 30
}

resource "aws_kms_key" "hourly" {
  description = "This key is used to encrypt bucket objects"
}

module "provision_hourly" {
  source            = "./.module"
  application_name  = local.config["application_name"]
  prefix            = "hourly"
  versioning        = true
  kms_master_key_id = aws_kms_key.hourly.arn
  user_id           = data.aws_canonical_user_id.current_user.id
  expiration_days   = 10
}
