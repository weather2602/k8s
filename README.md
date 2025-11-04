# k8s

Practice project for Kubernetes infrastructure management using Terraform.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.9.8 or later)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with appropriate permissions

## Local Development

### 1. Navigate to Terraform Directory

```bash
cd terraform/
```

### 2. Configure Environment Variables

Create a `.env` file in the `terraform/` directory with the following variables:

```bash
GCP_PROJECT_ID=your-project-id
TF_BACKEND_BUCKET=your-terraform-state-bucket
CICD_SERVICE_ACCOUNT=your-cicd-sa
WIF_PROVIDER=your-wif-path
```

Load the environment variables:

```bash
export $(grep -v '^#' .env | xargs)
```

### 3. Initialize Terraform

Initialize Terraform with the remote backend configuration:

```bash
terraform init \
  -backend-config="bucket=${TF_BACKEND_BUCKET}" \
  -backend-config="prefix=terraform/state"
```

### 4. Plan Infrastructure Changes

Preview the changes Terraform will make:

```bash
terraform plan -var="project_id=${GCP_PROJECT_ID}"
```

### 5. Apply Infrastructure Changes

Apply the Terraform configuration (after reviewing the plan):

```bash
terraform apply -var="project_id=${GCP_PROJECT_ID}"
```

## CI/CD Pipeline

This project uses GitHub Actions for automated Terraform planning on pull requests. The workflow:

- Authenticates to GCP using Workload Identity Federation
- Initializes Terraform with remote state
- Runs `terraform plan` to preview changes
- Validates and formats Terraform code

See `.github/workflows/terraform-plan.yml` for details.

## Security Notes

- Never commit `.env` files or secrets to version control
- Use GCP Workload Identity Federation for CI/CD authentication
- Store sensitive values in GitHub Secrets

## Useful Commands

```bash
# Format Terraform files
terraform fmt -recursive

# Validate Terraform configuration
terraform validate

# Show current state
terraform show

# Destroy infrastructure (use with caution!)
terraform destroy -var="project_id=${GCP_PROJECT_ID}"
```