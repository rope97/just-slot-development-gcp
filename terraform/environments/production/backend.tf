terraform {
  backend "gcs" {
    bucket = "just-slots-tfstate"
    prefix = "production"
  }
}
