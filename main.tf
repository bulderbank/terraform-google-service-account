variable "account_id" {
  description = "Name of the Google Service Account"
  type        = string
}

variable "project" {
  description = "Name of the GCP Project, defaults to root module provider configuration"
  type        = string
}


resource "google_service_account" "gsa" {
  account_id = var.account_id
  project    = var.project
}

output "email" {
  value = google_service_account.gsa.email
}

