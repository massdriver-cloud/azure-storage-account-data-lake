locals {
  max_length        = 24
  alphanumeric_name = substr(replace(var.md_metadata.name_prefix, "/[^a-z0-9]/", ""), 0, local.max_length)
}

resource "azurerm_resource_group" "main" {
  name     = var.md_metadata.name_prefix
  location = var.account.region
  tags     = var.md_metadata.default_tags
}

resource "azurerm_storage_account" "main" {
  name                     = local.alphanumeric_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_kind             = var.account.tier == "Premium" ? "BlockBlobStorage" : "StorageV2"
  account_tier             = var.account.tier
  account_replication_type = var.redundancy.replication_type
  access_tier              = var.account.access_tier
  is_hns_enabled           = true
  tags                     = var.md_metadata.default_tags

  blob_properties {
    delete_retention_policy {
      days = var.redundancy.data_protection
    }
    container_delete_retention_policy {
      days = var.redundancy.data_protection
    }
  }

  identity {
    type = "SystemAssigned"
  }
}
