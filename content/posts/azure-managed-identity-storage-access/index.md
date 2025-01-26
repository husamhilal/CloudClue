+++
author = "Husam Hilal"
title = "Using Azure Managed Identity to access Azure Storage Account using PowerShell"
date = "2025-01-02"
description = "Learn how to access Azure Storage Account authenticating with Azure Managed Identity using PowerShell"
image = "images/managed-identity-azure-storage.png"
aliases = ["azure-managed-identity-example"]
toc = false
tags = [
    "Storage Account",
    "PowerShell",
    "Managed Identity",
    "Security",
    "Azure Champ",
    "Entra ID",
    "Azure"
]
series = ["Azure Core"]
categories = ["Microsoft Azure"]
+++

## Background

In many occasions you will face the need to connect to an Azure Storage Account from an Azure VM (or VM Scale Set). 

## Problem

It can be through using some PowerShell script to connect to an Azure Storage Account to store or retrieve some data such as a blob within a container. At the same time, you would like to **store blobs securely and avoid having public accessible blobs**. You are more likely want to **avoid** the need to create Shared Access Signatures (**SAS** tokens), or even expose and manage the Storage Account **Access Keys**.

## Solution

Well! **The solution to that is through authenticating to the Storage Account using Azure Managed Identities**.

There are two two types of Azure Managed Identities: an Azure artifact that is backed with autonomous Azure EntraID Service Principal that is employing self-managed credentials:

* **System assigned managed identity**: It's a mapped identity to the resource (1-1 relationship), where the lifecycle of the identity is tied to the lifecycle of the Azure resource itself, it's an Azure responsibility.
* **User assigned managed identity**: It's an independent identity that can be assigned to multiple Azure resources  (1-∞ relationship), making it flexible. However, the lifecycle of the identity is managed separately from the resources, it's a Customer responsibility.

In this post, I will demonstrate using user assigned managed identity as it has various implementation scenarios. Before you start make sure that you have created a User assigned managed identity and assigned it to a VM in Azure.

You'll notice the following in the example script snipper below:

1. The following are the PowerShell modules needed to run the used cmdlets. Make sure to install them wherever you are running the script:

    * [Az.Accounts](https://learn.microsoft.com/powershell/module/az.accounts): Connect-AzAccount

    * [Az.Storage](https://learn.microsoft.com/powershell/module/az.storage): New-AzStorageContext, New-AzStorageContainer, Set-AzStorageBlobContent

    * [Az.ManagedServiceIdentity](https://learn.microsoft.com/powershell/module/az.managedserviceidentity/): Get-AzUserAssignedIdentity

2. Using parameter `-Identity` in `Connect-AzAccount` is the secret that allows us to leverage managed identities.  Providing the other parameter `-AccountId` is necessary only when there are more than one Managed Identity linked to the Azure resource, to solve the confusion. Otherwise the first managed identity in the list will be selected by default. In other words, it's not necessary if you are using only one user assigned managed identity or if you are using system assigned managed identity.

3. The cmdlet `Get-AzUserAssignedIdentity` was used to retrieve the `ClientId` of the managed identity. If you provide that value directly, then this line won't be necessary. Also, you would need to assign the managed identity **Reader** access over the resource group it belongs to.

4. When creating the Storage Account context, we needed to use the parameter `–UseConnectedAccount` to authenticate using OAuth Protocol. After creating the context, then you will continue interacting with Azure Storage Container similar as you do typically.

5. The permissions required to allow the managed identity to create a container and store a blob inside is **Storage Blob Data Contributor**.

```powershell
$resourceGroupName = '<resourceGroupName>'
$managedIdentityName = '<managedIdentityName>'
$storageAccountName = '<storageAccountName>'
$newContainerName = '<newContainerName>'
$uploadFilePath =  '<uploadFilePath i.e. c:\temp\image.png>'
$fileName = $uploadFilePath.Split('\')[-1]

#the following couple lines are optional if you are providing the ClientID directly
Connect-AzAccount -Identity
$managedIdentity = Get-AzUserAssignedIdentity -ResourceGroupName $resourceGroupName -Name $managedIdentityName

#using -AccountId is only necessary when you have multiple managed identities linked to the Azure resource (i.e. Storage Account)
Connect-AzAccount -Identity -AccountId $managedIdentity.ClientId

$storageAccount = New-AzStorageContext -StorageAccountName $storageAccountName –UseConnectedAccount

$container = New-AzStorageContainer -Name $newContainerName -Context $storageAccount.Context -Permission blob

Set-AzStorageBlobContent -File $uploadFilePath -Container $container.Name -Blob $fileName -Context $storageAccount.Context

```

As you noticed from the script-snippet above that there was no credentials/passwords/passphrases/secrets/keys/certificates exposed. That's a big advantage of using managed identities, especially when storing scripts in code repository 😉 Think about it as the **password-less infrastructure experience**. That's the beauty of Azure Managed Identities!

As a side note, the same approach is achievable through Azure CLI. You'll just need to use the equivalent commands.

I hope this was a good introduction for you to start leveraging managed identities in your scripts.