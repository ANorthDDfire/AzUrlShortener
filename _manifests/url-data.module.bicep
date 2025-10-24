@description('The location for the resource(s) to be deployed.')
param location string = resourceGroup().location

resource url_data 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: take('urldata${uniqueString(resourceGroup().id)}', 24)
  kind: 'StorageV2'
  location: location
  sku: {
    name: 'Standard_GRS'
  }
  properties: {
    accessTier: 'Hot'
    allowSharedKeyAccess: false
    minimumTlsVersion: 'TLS1_2'
    networkAcls: {
      defaultAction: 'Allow'
    }
  }
  tags: {
    'aspire-resource-name': 'url-data'
  }
}

resource blobs 'Microsoft.Storage/storageAccounts/blobServices@2024-01-01' = {
  name: 'default'
  parent: url_data
}

output blobEndpoint string = url_data.properties.primaryEndpoints.blob

output queueEndpoint string = url_data.properties.primaryEndpoints.queue

output tableEndpoint string = url_data.properties.primaryEndpoints.table

output name string = url_data.name