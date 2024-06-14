globals {
  terraform {
    required_version = ">= 1.0.0"
  }

  backend "s3" {
    bucket = "your-terraform-state-bucket"
    key    = "path/to/your/key"
    region = "us-west-2"
  }
}
