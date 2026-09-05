# CI/CD Pipeline & GitHub Actions Guide

This project leverages automated GitHub Actions workflows with strict security defaults.

---

## Workflows Overview

| Workflow | Trigger | Description |
| :--- | :--- | :--- |
| `validate.yml` | Push & PR | Checks format, validates syntax, runs TFLint (azurerm) and Checkov |
| `plan.yml` | Pull Request | Runs plan via Azure OIDC, generates architecture SVG, posts PR comment |
| `apply.yml` | Merge to `main` | Deploys infrastructure and updates post-apply architecture diagram |
| `diagram.yml` | Dispatch / HCL push | Renders standalone SVG diagram and commits to repo |
| `destroy.yml` | Manual Dispatch | Tears down resources when confirmed with `DESTROY` keyword |

---

## Azure OIDC Authentication

Workflows authenticate to Microsoft Azure using passwordless OpenID Connect (OIDC) through GitHub Actions:

### Required GitHub Secrets
1. `AZURE_CLIENT_ID`: The App Registration (Service Principal) Client ID.
2. `AZURE_TENANT_ID`: The Azure Active Directory (Entra ID) Tenant ID.
3. `AZURE_SUBSCRIPTION_ID`: The Azure Subscription ID.

### Federated Credential Configuration
In the Azure Portal or Azure CLI:
```bash
az ad app federated-credential create --id <APP_OBJECT_ID> --parameters '{
  "name": "github-actions-main",
  "issuer": "https://token.actions.githubusercontent.com",
  "subject": "repo:mchittineni/aks-terraform:ref:refs/heads/main",
  "audiences": ["api://AzureADTokenExchange"]
}'
```
