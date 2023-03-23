resource "massdriver_artifact" "azure_storage_account_data_lake" {
  field                = "azure_storage_account_data_lake"
  provider_resource_id = module.azure_storage_account.account_id
  name                 = "Azure Data Lake Storage Account ${var.md_metadata.name_prefix} (${module.azure_storage_account.account_id})"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          ari      = module.azure_storage_account.account_id
          endpoint = module.azure_storage_account.primary_dfs_endpoint
        }
        security = {
          iam = {
            "read" = {
              role  = "Storage Blob Data Reader"
              scope = module.azure_storage_account.account_id
            },
            "read_write" = {
              role  = "Storage Blob Data Contributor"
              scope = module.azure_storage_account.account_id
            }
          }
        }
      }
      specs = {
        azure = {
          region = azurerm_resource_group.main.location
        }
      }
    }
  )
}
