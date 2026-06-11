resource "kubernetes_deployment" "backend" {
  metadata {
    name = "game-backend"
    labels = {
      app = "game-backend"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "game-backend"
      }
    }

    template {
      metadata {
        labels = {
          app = "game-backend"
        }
      }

      spec {
        container {
          name  = "backend"
          image = var.image

          port {
            container_port = 3000
          }
        }
      }
    }
  }
}
