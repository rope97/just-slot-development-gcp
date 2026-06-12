resource "kubernetes_deployment" "backend" {
metadata {
name = "game-backend-${var.env}"
labels = {
  app = "game-backend-${var.env}"
}

}

spec {
replicas = 1

selector {
  match_labels = {
    app = "game-backend-${var.env}"
  }
}

template {
  metadata {
    labels = {
      app = "game-backend-${var.env}"
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

