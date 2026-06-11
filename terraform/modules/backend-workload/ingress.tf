resource "kubernetes_ingress_v1" "backend" {
  metadata {
    name = "game-backend-ingress"

    annotations = {
      "kubernetes.io/ingress.class" = "gce"
    }
  }

  spec {
    ingress_class_name = "gce"

    rule {
      host = var.host

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service.backend.metadata[0].name

              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
