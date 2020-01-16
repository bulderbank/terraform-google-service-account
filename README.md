# Google Service Account

Made for Terraform 0.12.x

### Code example

```
module "example_service_account" {
  source = "github.com/bulderbank/terraform-google-service-account"

  id   = "sa-example-account"
  name = "Example Service Account"

  create_key = true         // Can be omitted, defaults to false. True creates a service account key

  roles = [
    {
      "project" = var.google_project
      "role"    = "roles/iam.serviceAccountUser"
    },
    {
      "project" = var.google_project
      "role"    = "roles/bigquery.jobUser"
    },
    {
      "project" = var.google_project
      "role"    = "roles/bigquery.dataEditor"
    },
    {
      "project" = var.google_project
      "role"    = "roles/cloudfunctions.developer"
    },
  ]

  labels = {
    "created-by"  = "fredrick-myrvoll"
    "created-on"  = "2019-12-19"
    "environment" = var.environment
  }
}

output "sa_firequery_user" {        // Can be omitted, tf 0.12 requires outputs to be in root directory
  value = module.example_service_account.email
}

output "sa_firequery_key" {         // Can be omitted, tf 0.12 requires outputs to be in root directory
  value     = module.example_service_account.key
  sensitive = true
}
```

