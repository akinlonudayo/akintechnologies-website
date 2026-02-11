terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.30.0"
    }
  }
}

provider "aws" {
  region = "ca-central-1" # CHANGE this to your bucket's region
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
}