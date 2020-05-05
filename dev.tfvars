id   = "sa-example-account"
name = "Example Service Account"

create_key = true

roles = [
  {
    "project" = "module-dev"
    "role"    = "roles/iam.serviceAccountUser"
  },
  {
    "project" = "module-dev"
    "role"    = "roles/bigquery.jobUser"
  },
  {
    "project" = "module-dev"
    "role"    = "roles/bigquery.dataEditor"
  },
  {
    "project" = "module-dev"
    "role"    = "roles/cloudfunctions.developer"
  },
]

labels = {
  "created-by"  = "fredrick-myrvoll"
  "created-on"  = "2019-12-19"
  "environment" = "dev"
}