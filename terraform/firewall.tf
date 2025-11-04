resource "google_compute_firewall" "allow_internal" {
  name    = "k8s-allow-internal"
  network = google_compute_network.k8s_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.network_cidr]
}

