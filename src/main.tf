resource "azurerm_resource_group" "main" {
  name     = var.md_metadata.name_prefix
  location = var.account.region
  tags     = var.md_metadata.default_tags
}

module "azure_storage_account" {
  source              = "github.com/massdriver-cloud/terraform-modules//azure/storage-account?ref=be3b9a8"
  name                = var.md_metadata.name_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  kind                = var.account.tier == "Premium" ? "BlockBlobStorage" : "StorageV2"
  tier                = var.account.tier
  replication_type    = var.redundancy.replication_type
  access_tier         = var.account.access_tier
  enable_data_lake    = true
  tags                = var.md_metadata.default_tags

  blob_properties = {
    delete_retention_policy           = var.redundancy.data_protection
    container_delete_retention_policy = var.redundancy.data_protection
  }
}
