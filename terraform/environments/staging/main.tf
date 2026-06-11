provider "google" {
  project = "just-slots-499010"
  region  = "europe-west1"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
module "registry" {
  source = "../../modules/registry"
}

module "gke" {
  source = "../../modules/gke"

  cluster_name = "just-slots-staging"

}

module "backend_workload" {
  source = "../../modules/backend-workload"

  image = "europe-west1-docker.pkg.dev/just-slots-499010/game-backend/api:staging"
  host  = "api-staging.slots.com"
}
module "static_site" {
  source = "../../modules/static-site"

  bucket_name = "just-slots-fe-${var.env}"
  location    = "EUROPE-WEST1"
}
