variable "account_id" {
  description = "Name of the Google Service Account"
  type        = string
}

variable "project" {
  description = "Name of the GCP Project, defaults to root module provider configuration"
  type        = string
}

variable "create_json_key" {
  type     = bool
  nullable = false
  default  = false
}


resource "google_service_account" "gsa" {
  account_id = var.account_id
  project    = var.project
}

resource "google_service_account_key" "json" {
  count              = var.create_json_key ? 1 : 0
  service_account_id = google_service_account.gsa.account_id
}

output "email" {
  value = google_service_account.gsa.email
}

output "json_key" {
  value = var.create_json_key ? google_service_account_key.json[0].private_key : null
}

