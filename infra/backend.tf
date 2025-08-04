
terraform {
  backend "s3" {
    bucket = "obinna-backends"
    key    = "fake_data/data.tfstate"
    region = "eu-west-2"
  }
}