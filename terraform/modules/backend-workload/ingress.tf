resource "kubernetes_manifest" "backend_cert" {
  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "ManagedCertificate"

    metadata = {
      name = "backend-cert-${var.env}"
      namespace = "default"
    }

    spec = {
      domains = [
        var.host
      ]
    }
  }
}

resource "kubernetes_ingress_v1" "backend" {
  metadata {
    name = "game-backend-ingress-${var.env}"

    annotations = {
      "kubernetes.io/ingress.class" = "gce"
    "networking.gke.io/managed-certificates" = "backend-cert-${var.env}"
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
