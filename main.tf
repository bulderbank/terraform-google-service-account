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

variable "create_gsm_secret" {
  type     = bool
  nullable = false
  default  = true
}


resource "google_service_account" "gsa" {
  account_id = var.account_id
  project    = var.project
}

resource "google_service_account_key" "json" {
  count              = var.create_json_key ? 1 : 0
  service_account_id = google_service_account.gsa.account_id
}

resource "google_secret_manager_secret" "json" {
  count     = var.create_json_key && var.create_gsm_secret ? 1 : 0
  secret_id = "${var.account_id}-json-key"

  labels = {
    created_with = "terraform"
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "json" {
  count       = var.create_json_key && var.create_gsm_secret ? 1 : 0
  secret      = google_secret_manager_secret.json[0].id
  secret_data = base64decode(google_service_account_key.json[0].private_key)
}

output "email" {
  value = google_service_account.gsa.email
}

output "json_key" {
  value = var.create_json_key ? google_service_account_key.json[0].private_key : null
}

