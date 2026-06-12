resource "kubernetes_service" "backend" {
  metadata {
    name = "game-backend-service-${var.env}"
  }

  spec {
    selector = {
      app = "game-backend-${var.env}"
    }

    type = "NodePort"

    port {
      port        = 80
      target_port = 3000
    }
  }
}
