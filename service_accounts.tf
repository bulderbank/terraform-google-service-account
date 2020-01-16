resource "google_service_account" "sa" {
  project      = var.google_project
  account_id   = var.id
  display_name = var.name

  depends_on = [google_project_service.iam]
}

resource "google_project_iam_member" "sa" {
  count   = length(var.roles)
  member  = "serviceAccount:${google_service_account.sa.email}"
  project = lookup(var.roles[count.index], "google_project", "")
  role    = var.roles[count.index]["role"]
}

resource "google_service_account_key" "sa" {
  count = var.create_key ? 1 : 0

  service_account_id = google_service_account.sa.name
}
