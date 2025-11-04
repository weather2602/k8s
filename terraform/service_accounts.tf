resource "google_service_account" "k8s_nodes" {
  account_id   = "k8s-nodes"
  display_name = "Service account for Kubernetes nodes"
}
