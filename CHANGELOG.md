# v4.1.0 - 2022-02-15

Added
  * AZ-615: Add an option to enable or disable default tags

Changed
  * AZ-572: Revamp examples and improve CI

# v4.0.1 - 2021-08-27

Updated
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module, fix linter errors

# v4.0.0 - 2021-01-21

Breaking
  * AZ-344: Back to a single resource, because we can now use `for_each` on a module since Terraform `v0.13+`

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

Changed
  * AZ-398: Force lowercase on default generated name

# v3.0.0 - 2020-07-22

Breaking
  * AZ-198: Upgrade module to be compliant with AzureRM 2.0

# v2.2.0 - 2020-07-09

Fixed

  * AZ-206: Pin version of provider AzureRM to be usable under v2.x

Added

  * AZ-215: Manage installation of gpg package on VMs

Breaking

  * AZ-147: REVERT - From `count` to `for_each` with input variable changes

# v2.1.0 - 2020-02-07

Breaking

  * AZ-147: Manage list for VM IDs (input variable type changed)
  * AZ-147: From `count` to `for_each` with input variable changes

# v2.0.1 - 2019-10-07

Changed

  * AZ-119: Documentation improvements

# v2.0.0 - 2019-09-30

Breaking

  * AZ-94: Terraform 0.12 / HCL2 format

Added

  * AZ-118: Add LICENSE, NOTICE & Github badges
  * AZ-119: Add CONTRIBUTING.md doc and `terraform-wrapper` usage with the module

Changed

  * AZ-119: Revamp README and publish this module to Terraform registry

# v0.3.1 - 2019-07-01

Changed

  * AZ-82: Update README

# v0.3.0 - 2019-04-25

Changed

  * AZ-82: Add variable to customize log level

# v0.2.0 - 2019-04-01

Changed

  * AZ-21: Azure VM Linux - Diagnostics extension v3.0

# v0.1.0 - 2019-03-11

Added

  * AZ-4/21: First Release. Azure VM Linux - Diagnostics extension v2.3
