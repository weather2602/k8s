output "controlplane_internal_ip" {
  value = google_compute_instance.controlplane.network_interface[0].network_ip
}

output "worker_internal_ip" {
  value = google_compute_instance.worker.network_interface[0].network_ip
}
