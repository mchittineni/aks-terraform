# Azure AKS Architecture Specification

This document details the architectural layout, network topology, security model, and component interactions of the Azure Kubernetes Service infrastructure.

---

## Visual Architecture

![Azure Architecture Diagram](architecture.svg)

---

## Core Components

### 1. Virtual Network (VNet) & Networking
- **Address Space**: `10.0.0.0/16`
- **Subnet Layout**:
  - `subnet-01` (`10.0.1.0/24`): Primary AKS node pool subnet.
  - `subnet-02` (`10.0.2.0/24`): Database and private endpoints.
  - `subnet-03` (`10.0.3.0/24`): Ingress controllers and application gateways.
- **Network Security Groups (NSG)**: Default NSG protecting subnets with strict internal allow rules and restricted internet ingress.

### 2. Azure Kubernetes Service (AKS)
- **Version**: Kubernetes `1.32`
- **Node Pool**: Managed System Node Pool using `Standard_D2s_v5` Ubuntu Linux nodes.
- **Identity**: Azure System-Assigned Managed Identity.
- **Network Model**: Azure CNI with Azure Network Policy.
- **RBAC**: Azure Active Directory / Entra ID role-based access control enabled.

### 3. Database Layer
- **Service**: Azure SQL Database
- **Engine**: Microsoft SQL Server v12.0
- **Security**:
  - Minimum TLS version `1.2`.
  - Auditing and threat detection policies enabled.
  - VNet rule integration restricting access to application subnets.

### 4. Monitoring & Observability
- **Log Analytics Workspace**: Centralized ingestion for container logs and resource metrics.
- **Container Insights**: Live performance diagnostics, pod metrics, and node utilization tracking.
- **Action Groups**: Configured for administrative alerts and threshold alerts sent via email.
