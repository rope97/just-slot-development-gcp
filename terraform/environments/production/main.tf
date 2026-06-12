provider "google" {
project = "just-slots-499010"
region  = "us-central1"
}

provider "kubernetes" {
config_path = "~/.kube/config"
}

module "registry" {
source = "../../modules/registry"
}

module "backend_workload" {
source = "../../modules/backend-workload"

env   = "production"
image = "europe-west1-docker.pkg.dev/just-slots-499010/game-backend/api:prod"
host  = "api-slots.duckdns.org"
}

module "static_site" {
source = "../../modules/static-site"

bucket_name = "just-slots-fe-prod"
location    = "US"
}
