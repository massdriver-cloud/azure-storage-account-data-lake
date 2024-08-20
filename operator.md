## Azure Data Lake Storage Account

Azure Data Lake Storage (ADLS) is a highly scalable and secure data lake that allows enterprises to capture data of any size, type, and ingestion speed for analytics and operational data. ADLS integrates with Azure Blob Storage to provide a hierarchical namespace, enabling fine-grained access controls, high-performance data access, and integration with other Azure services like Azure Synapse Analytics and Azure Databricks.

### Design Decisions

- **Enable Data Lake**: Data Lake is enabled in the storage account to support hierarchical namespace and efficient data access.
- **Replication and Redundancy**: Configurable replication types based on the need for redundancy and disaster recovery. Options include LRS, ZRS, GRS, and RA-GRS.
- **Access Tiers**: Includes support for hot and cool access tiers to optimize costs based on data access patterns.
- **Blob Properties**: Includes configuration for delete retention policies to prevent accidental deletions.
- **Monitoring and Alarms**: Automatic configuration of monitoring alerts for availability and latency to ensure system health and performance.
- **IAM Roles**: Configures appropriate IAM roles for read and read/write access using Azure RBAC.

### Runbook

#### Checking Storage Account Availability

If the storage account is not accessible, verify its availability status.

```sh
az storage account show --name <storage_account_name> --resource-group <resource_group>
```
Check the `statusOfPrimary` value to ensure it is `available`.

#### Access Issues with Storage Account

If there are permission or access issues, verify the IAM role assignments.

```sh
az role assignment list --scope /subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>
```
Ensure that the required `Storage Blob Data Reader` and `Storage Blob Data Contributor` roles are assigned.

#### Monitoring Alerts for Latency and Availability

To troubleshoot latency or availability issues, check the configured metric alerts.

```sh
az monitor metrics alert list --resource-group <resource_group> --resource /subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name>
```
Verify that alerts for availability and latency are set up correctly and check any triggered alerts.

#### Data Access Latency

If experiencing high latency with E2E or server access, check the corresponding metrics.

```sh
az monitor metrics list --resource /subscriptions/<subscription_id>/resourceGroups/<resource_group>/providers/Microsoft.Storage/storageAccounts/<storage_account_name> --metric SuccessE2ELatency,SuccessServerLatency
```
Review the metrics values and compare them against the configured thresholds to identify if there are any performance issues.

Ensure appropriate actions are taken based on the alerts and metrics observations. Use the Azure portal or CLI to adjust configurations as needed.

