resource "google_compute_router" "k8s_router" {
  name    = "k8s-router"
  network = google_compute_network.k8s_vpc.name
  region  = "europe-west8"
}

resource "google_compute_router_nat" "k8s_nat" {
  name                               = "k8s-nat"
  router                             = google_compute_router.k8s_router.name
  region                             = google_compute_router.k8s_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
