+++
author = "Husam Hilal"
title = "Azure VMware Solution for Azure Experts"
date = "2025-01-21"
description = "Explore Azure VMware Solution experience in Azure as an Azure Subject Matter Expert"
image = "images/avs-for-azure-expert.png"
aliases = ["avs-azure-experience"]
toc = true
tags = [
    "AVS",
    "VMware",
    "Azure",
    "Azure Champ",
    "Level 200"
]
series = ["Azure VMware Solution"]
categories = ["Microsoft Azure"]
+++

# Azure VMware Solution - The Azure Experience

Azure VMware Solution (AVS) bridges the gap between traditional VMware environments and modern Azure services, allowing customers to easily migrate, run, manage, and secure VMware workloads natively on Azure.

In the context of AVS, exploring Azure and VMware vSphere is like examining a coin—each side complements the other. In this blog, I’ll focus on the Azure side of the coin, diving into how AVS integrates with Azure. In a future blog, I’ll flip the coin to reveal the VMware side.

{{< notice info >}}
I am going to call Azure VMware Solution – "**AVS**" – for simplicity. However, it is not an official acronym
{{< /notice >}}

## AVS as an Azure Resource

AVS is represented as a resource provider within Azure **Microsoft.AVS**. You must [register this provider](https://learn.microsoft.com/azure/azure-vmware/deploy-azure-vmware-solution?tabs=azure-portal#register-the-microsoftavs-resource-provider) in your Azure subscription before provisioning AVS. This step parallels other Azure services, ensuring subscription readiness for specific workloads. If not registered, you cannot deploy AVS private cloud resources; users may see an error at deployment even if they have quota allocation. When an instance is deployed it is represented as `microsoft.avs/privateclouds`.

### Quota Requests

When you set up an Azure subscription, you begin with **zero quota**, unlike other Azure services where a default allocation may exists (e.g., compute cores for Virtual Machines). To deploy an AVS private cloud, customers must explicitly request a minimum quota of **three hosts**. This minimum is required to support **vSAN fault tolerance and data redundancy**, ensuring resilience during host failures. For example, a cluster with three nodes can handle one node's failure without data loss. It is important to mention here that customers can request additional quota to scale up their existing cluster or provision additional clusters.

## Exploring the Azure Portal for AVS

The [Azure Portal](https://learn.microsoft.com/azure/azure-portal/azure-portal-overview) provides an intuitive experience for managing AVS. Here’s a breakdown of key tabs in the service menu:

### Overview

Under Overview you will find few key things you need to be aware of:

#### JSON View

Displays AVS resource properties in plain JSON format. You can select the latest API version and review key resource attributes. Most of these properties are available when browsing the service menu views in the AVS blade in Azure Portal. I find it easier to use the JSON view to get certain information (e.g. find the IP address of vCenter).

#### Essentials

Essentials section provides some high-level information about the AVS private cloud  resource, including: *Resource Group*, *Status*, *Location* (Azure region), *Subscription*, *Tags*, *Management address block*, *Availability Zone* within the region.

{{< notice info >}}
**Network Address Blocks**:
AVS private cloud **management** components requires a minimum of a /22 network address block. Additionally, a /24 address block may be needed for **Multipath Input/Output** (MPIO) when adding external storage services that use iSCSI technology. A /23 address block might also be required for deploying additional clusters of the **AV64** SKU, an Azure fleet SKU. 
The **key consideration** when selecting these network address blocks is ensuring they do not overlap with other networks, such as on-premises networks, Azure Virtual Networks, or Azure Virtual WAN hubs.
{{< /notice >}}

#### Get started and Tutorials

At the button of the page you will find two sections for **Get started** and **Tutorials** which provide helpful links to get you started learning about the service.

### Activity Logs

Activity Logs provide an audit trail of changes and operations on the AVS private cloud, ensuring traceability. This is similar to other Azure Resources.

### Access Control (IAM)

Similar to other Azure resources, AVS provides Access Control (IAM), where you can assign various levels of access, such as *Owner*, *Contributor*, *Reader*, or *custom roles*.

{{< notice info >}}
 It’s important to note that these permissions apply only to the Azure resource itself and are used to manage properties exposed through Azure APIs. They **do not affect** workloads within the VMware vSphere environment, such as VMs, network segments, or other vSphere resources. Permissions for those resources are managed separately through vCenter (vSphere Client) and NSX Manager.
{{< /notice >}}

### Diagnose and Solve Problems

This section offers troubleshooting tools and common problem resolutions. You can also see the most recent Azure health events if any. You can configure **service health alerts rules**, notifying relevant personnel of Azure health events related to AVS. This is similar to other Azure Resources.

### Locks

Similar to other Azure services, the **Lock** feature can be found under **Settings**. This feature helps prevent users from accidentily deleting or modifying resource properties by making them read-only.

- **Delete Lock**: Prevents deletion of AVS private cloud instance regardless of the user roles and RBAC permissions. 
- **Read-only Lock**: Prevents unintended changes to resource properties to avoid unplanned interruptions.

{{< notice info >}}
 Enabling locks is a best practice for production environments. Keep in mind that only the **Owner** and **User Access Administrator** built-in roles can create or delete management locks.
{{< /notice >}}

## Unique Features of AVS in Azure Portal

The AVS blade includes service-specific management sections:

### Manage

This section allows you to manage AVS private cloud specific configurations.

#### Connectivity

AVS offers multiple connectivity options to integrate with the Azure ecosystem and on-premises environments to enable hybrid cloud or full data center evacuation:  

- **Azure vNet Connect**:  his helps connecting the AVS private cloud to an Azure Virtual Network (vNet) through an internal ExpressRoute connection. As a **cost advantage** there are no charges for the internal ExpressRoute connectivity. This is just a shortcut method, see the next bullet for configuring the same connectivity manually.  

- **ExpressRoute Authorization**: Provides the ability to request an Authorization Key, required to establish an ExpressRoute connection with the AVS-provided ExpressRoute circuit. This section also allows you to retrieve the **ExpressRoute Circuit ID** and **Private Peering ID** for configuration.  

- **ExpressRoute Global Reach**: This option is ideal for customers with existing ExpressRoute connectivity to Azure and do not have complicated network inspection requirements. Where it enables connectivity between the private peering of two ExpressRoute circuits, such as:  
  - On-premises to Azure.  
  - AVS private cloud.

This can also be helpful for connecting multiple AVS private cloud instances located in different regions. But be mindful that Global Reach is not available in all Azure regions.

#### Clusters

This sections enabled you to manage AVS clusters:

- **Add** or **remove** hosts in existing clusters (e.g. add AV64 clusters for capacity expansion.)
- Deploy new clusters (minimum of three hosts in each).
- Delete existing clusters if no longer used.

Couple considerations to keep in mind:

- Currently, AVS private cloud needs to have the first (aka seed or initial) cluster of AV36 or AV36P, and expand capacity by adding AV64 clusters (recommended). For, AV64 an additional management address block need to be configured under **Extended address block** accessible from the Clusters section.
- To add additional hosts, make sure you have enough quota. You may need to request additional quota when you expect to add capacity. Hosts will be added to an existing cluster in parallel. The operation takes about 30 minutes.

#### **Encryption**  

Configure **Customer Managed Keys (CMK)** stored in Azure Key Vault for vSAN encryption. For compliance, Azure Key Vault HSM can provide FIPS 140-2 Level 2 or 3 protection.

#### **VMware Credentials**  
Access **CloudAdmin credentials** for vSphere and NSX Manager. Passwords can be rotated here, and URI certificates verified.

#### **Identity**  
Enable **system-assigned managed identity** for AVS to integrate with Azure Key Vault for encryption.

#### **Storage**  
Attach additional datastores, such as **Azure NetApp Files** or **Azure Elastic SAN**, to extend storage without adding hosts. **Pure Storage** is also an option for datastore integration.

#### **Placement Policies**  
Define VM placement policies, such as:
- VM-Host Affinity/Anti-affinity
- VM-VM Affinity/Anti-affinity  
These policies can optimize licensing costs (e.g., SQL Server, Oracle).

#### **Add-ons**  
Enable key VMware solutions:
1. **VMware HCX**: Included for seamless workload migration.
2. **VMware SRM (Live Site Recovery)**: Requires additional licensing for disaster recovery.
3. **Azure Arc**: Enables CRUD operations on AVS VMs via Azure APIs.

#### **vCenter Server Inventory**  
If AVS is Arc-enabled, users can:
- View and manage VMs.
- Enable Azure services like **Monitor** and **Defender for Cloud**.

#### **Workload Networks**  
Manage NSX segments and configurations:
- Configure DHCP and DNS services.
- Establish **Internet connectivity options**:
  - Managed SNAT.
  - Public IP for advanced NSX configurations.

#### **Operations**  
Includes:
1. **Azure Arc verification**.
2. **Run Commands**: Perform elevated operations (e.g., configure storage policies, restart HCX Manager).

### Monitoring and Diagnostics  
Similar to other Azure resources, AVS offers:
- **Metrics**: Track CPU, memory, and datastore utilization.
- **Alerts**: Configure rules based on resource metrics.
- **Diagnostic Settings**: Export syslogs and metrics to destinations like Azure Log Analytics.

---

### Final Thoughts  
AVS combines the familiarity of VMware with the scalability of Azure, offering a seamless private cloud experience. While it integrates tightly with Azure’s ecosystem, its unique requirements, such as quotas, network planning, and specialized management options, make it crucial for administrators to understand the AVS lifecycle. With tools and settings tailored for enterprise needs, AVS empowers businesses to innovate securely and efficiently in the cloud.

