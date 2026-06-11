resource "kubernetes_service" "backend" {
  metadata {
    name = "game-backend-service"
  }

  spec {
    selector = {
      app = "game-backend"
    }

    type = "ClusterIP"
    port {
      port        = 80
      target_port = 3000
    }
  }
}
