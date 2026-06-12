resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = "europe-west1"
  deletion_protection = false
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "default-pool"
  cluster  = google_container_cluster.primary.name
  location = "europe-west1"

  node_count = 1

  node_config {
    machine_type = "e2-small"
    disk_size_gb = 20
    disk_type = "pd-standard"
  }
}
