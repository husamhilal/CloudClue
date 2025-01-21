+++
author = "Husam Hilal"
title = "Azure VMware Solution for Azure Experts"
date = "2025-01-14"
description = "Explore Azure VMware Solution experience in Azure as an Azure Subject Matter Expert"
image = "images/avs-for-azure-expert.png"
aliases = ["avs-azure-experience"]
toc = false
tags = [
    "AVS",
    "VMware",
    "Azure",
    "Azure Champ"
]
series = ["Azure VMware Solution"]
categories = ["Microsoft Azure"]
+++

**Azure VMware Solution - The Azure Experiense**

Azure VMware Solution (AVS) bridges the gap between traditional VMware environments and modern Azure services, allowing customers to run, manage, and secure VMware workloads natively on Azure. From the perspective of Azure architecture, AVS introduces unique considerations, behaviors, and management workflows.

### AVS as an Azure Resource  
AVS is represented as a resource type within Azure: `microsoft.avs/privateclouds`. Managed through the **Microsoft.AVS Resource Provider**, customers must register this provider in their Azure subscription before provisioning AVS. Without registration, you cannot deploy AVS private cloud resources. This step parallels other Azure services, ensuring subscription readiness for specific workloads.

### Quota Requests: The Starting Point for AVS  
When you set up AVS, you begin with **zero quota**, unlike other Azure services where a default allocation exists (e.g., compute cores for VMs). To deploy an AVS private cloud, customers must explicitly request a minimum quota of **three hosts**. This minimum is required to support **vSAN fault tolerance and data redundancy**, ensuring resilience during host failures. For example, a cluster with three nodes can handle one node's failure without data loss. Customers can later expand their clusters by requesting additional quotas.

### Exploring the Azure Portal for AVS  
The Azure Portal provides an intuitive experience for managing AVS. Here’s a breakdown of key areas:

#### **Overview Tab**  
The **Overview** tab gives high-level insights:
1. **JSON View**: Displays AVS resource properties in plain JSON format. Users can select the latest API version and review key resource attributes such as status, location, address blocks, and more.
2. **Essentials**: Shows critical resource information, including:
   - Subscription
   - Resource Group
   - Status
   - Location (Azure region)
   - Management address block (requires a minimum **/22 subnet**) and options for storage services requiring **/24 subnets** (e.g., iSCSI-based MPIO).
   - Availability Zone within the region.
   - Tutorials and helpful links at the bottom.

#### **Activity Logs**  
Activity Logs provide an audit trail of changes and operations on the AVS private cloud, ensuring traceability.

#### **Access Control (IAM)**  
IAM roles—Owner, Contributor, Reader, or custom roles—manage AVS resources through Azure APIs. However, these roles **do not extend** to workloads running inside VMware vSphere (e.g., VMs, segments). Permissions for these must be set through vSphere or NSX Manager.

#### **Diagnose and Solve Problems**  
This section offers troubleshooting tools and common problem resolutions. You can configure **service health alerts**, notifying relevant personnel of Azure health events.

#### **Locks**  
Azure Locks prevent accidental deletion or modification of resources:
- **Delete Lock**: Prevents deletion of AVS.
- **Read-only Lock**: Prevents unintended changes to resource properties. Enabling locks is a best practice for production environments.

### Unique Features of AVS in Azure Portal  
The AVS blade includes service-specific management options:

#### **Connectivity**  
This section allows you to:
1. Establish **internal ExpressRoute connections** to Azure VNets. (No additional charges apply.)
2. Authorize **ExpressRoute circuits** for on-premises connections.
3. Use **ExpressRoute Global Reach** to link AVS private clouds across regions or connect on-premises to AVS.

#### **Clusters**  
Manage AVS clusters here:
- Add or remove hosts in existing clusters.
- Deploy new clusters (minimum of three nodes each).
- Add AV64 clusters for capacity expansion.

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

