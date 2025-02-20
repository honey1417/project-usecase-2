terraform {
  required_version = "~>1.10.3"
    required_providers {
      google = {
        source  = "hashicorp/google"
        version = "~>6.17.0"
      }
    }
    backend "gcs" {
      bucket = "harshini-450807-bucket"
      prefix = "terraform/state"
    }
    
  }
    
provider "google" {
  project     = var.PROJECT_ID
  region      = var.REGION
  zone        = var.zone
}