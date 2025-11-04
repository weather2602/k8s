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

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "k8s-allow-iap-ssh"
  network = google_compute_network.k8s_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]

  target_tags = ["iap-ssh"]
}

resource "google_compute_firewall" "allow_egress_internet" {
  name      = "k8s-allow-egress-internet"
  network   = google_compute_network.k8s_vpc.name
  direction = "EGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  destination_ranges = ["0.0.0.0/0"]
}
