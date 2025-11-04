# k8s
Practice project for kubernetes

## local plan
terraform init -backend-config="bucket=${TF_BACKEND_BUCKET}" -backend-config="prefix=terraform/state"
terraform plan -var="project_id=${GCP_PROJECT_ID}"