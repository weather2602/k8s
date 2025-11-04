resource "google_compute_instance" "controlplane" {
  name         = "k8s-controlplane"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240927"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnet.id
  }

  tags = ["k8s-node", "controlplane"]
}

resource "google_compute_instance" "worker" {
  name         = "k8s-worker"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20240927"
      size  = 50
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.k8s_subnet.id
  }

  tags = ["k8s-node", "worker"]
}
