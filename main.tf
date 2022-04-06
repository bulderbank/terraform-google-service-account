variable "account_id" {
  description = "Name of the Google Service Account"
  type        = string
}

variable "project" {
  default     = ""
  description = "Name of the GCP Project, defaults to root module provider configuration"
  type        = string
}

variable "iam_roles" {
  default     = []
  description = "A list of assignment rules for pre-existing IAM roles"
  type        = any

  # TODO: Do this when `optional()` is no longer experimental
  # type = list(object({
  #   type    = string
  #   name    = string
  #   roles   = list(string)
  #   project = optional(string)
  # })
}

variable "iam_permissions" {
  default     = []
  description = "A list of permissions that will be added to a new custom role, and bound to the service account"
  type        = any

  # TODO: Do this when `optional()` is no longer experimental
  # type = list(object({
  #   type        = string
  #   name        = string
  #   project     = optional(string)
  #   permissions = list(string)
  # })
}

data "google_project" "target" {
  project_id = var.project
}

locals {
  description = "Created by Terraform via bulderbank/terraform-google-service-account"
  member      = "serviceAccount:${google_service_account.gsa.email}"

  # Modify `var.iam_roles` by adding the service account to the `member` parameter for each entry
  iam_member = [
    for rule in var.iam_roles : {
      type    = rule.type
      name    = rule.name
      member  = local.member
      roles   = rule.roles
      project = data.google_project.target.project_id
    }
  ]

  # Modify `var.permissions` into the format expected by the IAM module
  custom_roles = [
    for rule in var.iam_permissions : {
      id          = replace(join(".", [var.account_id, rule.type, rule.name]), "-", "")
      project     = data.google_project.target.project_id
      title       = "Custom role bound to ${var.account_id} for ${rule.name} (${rule.type})"
      description = local.description
      permissions = rule.permissions
    }
  ]

  iam_bindings = [
    for rule in var.iam_permissions : {
      type    = rule.type
      name    = rule.name
      members = [local.member]
      role    = "projects/${data.google_project.target.project_id}/roles/${replace(join(".", [var.account_id, rule.type, rule.name]), "-", "")}"
      project = data.google_project.target.project_id
    }
  ]
}


#
## Service account
#

resource "google_service_account" "gsa" {
  account_id  = var.account_id
  project     = var.project
  description = local.description
}


#
## IAM
#

module "iam" {
  source     = "github.com/bulderbank/terraform-google-iam?ref=v0.1.0"
  depends_on = [google_service_account.gsa]

  custom_roles = local.custom_roles
  iam_members  = local.iam_members
  iam_bindings = local.iam_bindings
}

