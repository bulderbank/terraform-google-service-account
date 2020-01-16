resource "google_project_service" "iam" {
  project = var.google_project
  service = "iam.googleapis.com"

  disable_dependent_services = true
}
