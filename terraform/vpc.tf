# resource "google_compute_network" "k8s_vpc" {
#   name                    = "k8s-vpc"
#   auto_create_subnetworks = false
# }

# resource "google_compute_subnetwork" "k8s_subnet" {
#   name          = "k8s-subnet"
#   region        = var.region
#   network       = google_compute_network.k8s_vpc.id
#   ip_cidr_range = var.network_cidr
# }
