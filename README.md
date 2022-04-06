# bulderbank/terraform-google-service-account

This is a module for creating Google Service Accounts, and assigning IAM roles to them by calling
[bulderbank/terraform-google-iam](https://github.com/bulderbank/terraform-google-iam) as a sub-module.

The module can be used to:
- Create service accounts
- Assign the service account to pre-existing roles for projects, buckets and secrets
- Bind the service account to a unique custom role with some set of permissions

### Usage

All the examples below assume that you are using a `config.yaml` file to pass configuration values to Terraform via `locals`:

```
# my-project/locals.tf

locals {
  config = yamldecode(file("${path.root}/config.yaml"))
}
```
```
# my-project/modules.tf

module "gsa" {
  source   = "github.com/bulderbank/terraform-google-service-account?ref=vX.Y.Z"
  for_each = local.config.serviceAccounts

  account_id      = each.key
  project         = lookup(each.value, "project", "")
  iam_roles       = lookup(each.value, "iamRoles", [])
  iam_permissions = lookup(each.value, "permissions", [])
}
```

##### Non-authoritative role assignment

One can assign pre-existing roles to the newly created service account via the `iam_roles` variable.

```
# my-project/config.yaml

serviceAccounts:
  example-account:
    iamRoles:
      - type: project
        name: my-project
        roles:
          - roles/dns.admin
          - roles/secretmanager.viewer
      - type: bucket
        name: my-bucket
        roles:
          - roles/storage.admin
```

##### Binding a unique custom role

It's often preferable to create a custom role that only contains the permissions required by the service account.
This can be done via the `iam_permissions` variable.
Each object in the list of inputs to this variable will lead to the creation of a custom role that gets assigned to the service account with an IAM binding.
This can be done for GCP projects, secrets, and storage buckets.


```
# my-project/config.yaml

serviceAccounts:
  example-account:
    permissions:
      - type: secret
        name: my-secret
        permissions:
          - secretmanager.versions.access
      - type: secret
        name: my-other-secret
        project: my-other-project
        permissions:
          - secretmanager.versions.access
```

