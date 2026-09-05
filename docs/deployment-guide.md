# Deployment Guide

A step-by-step walkthrough for deploying the Azure AKS Terraform infrastructure locally or via CI/CD.

---

## Prerequisites
1. **Azure CLI**: `az login`
2. **Terraform**: `1.16.1+`
3. **Azure Permissions**: Contributor role on the target Subscription.

---

## Deployment Steps

### Step 1: Clone Repository
```bash
git clone https://github.com/mchittineni/aks-terraform.git
cd aks-terraform
```

### Step 2: Configure Environment
Copy the example variables file and adjust parameters:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars`:
```hcl
azure_subscription_id = "your-subscription-id"
azure_location        = "eastus"
project_name          = "cloud-platform"
environment           = "dev"
```

### Step 3: Initialize Terraform
```bash
terraform init
```

### Step 4: Validate and Plan
```bash
terraform validate
terraform plan -out=tfplan
```

### Step 5: Apply Infrastructure
```bash
terraform apply tfplan
```

### Step 6: Connect to Kubernetes
```bash
az aks get-credentials --resource-group cloud-platform-dev-rg --name cloud-platform-dev-aks
kubectl get nodes
```
