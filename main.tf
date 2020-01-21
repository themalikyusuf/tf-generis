# Configure the AWS Provider
provider "aws" {
  #  access_key = "${var.aws_access_key}"
  #  secret_key = "${var.aws_secret_key}"
  profile = "${var.profile}"
  region  = "${var.aws_region}"
  version = "~> 1.39"
}

provider "aws" {
  #  access_key = "${var.aws_access_key}"
  #  secret_key = "${var.aws_secret_key}"
  profile = "${var.profile}"
  alias = "us-east-1"
  region  = "us-east-1"
  version = "~> 1.39"
}

terraform {
  required_version = ">= 0.11.10"
}

# create an api gateway

resource "aws_api_gateway_rest_api" "TestAPI" {
  name        = "TestAPI"
  description = "This is a Test API for demonstration purposes"
}

resource "aws_api_gateway_resource" "MyTestResource" {
  rest_api_id = "${aws_api_gateway_rest_api.TestAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.TestAPI.root_resource_id}"
  path_part   = "mytestresource"
}