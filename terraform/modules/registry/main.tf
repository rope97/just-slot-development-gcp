resource "google_artifact_registry_repository" "repo" {
  location      = "europe-west1"
  repository_id = "game-backend"
  format        = "DOCKER"
}
