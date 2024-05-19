

resource "kubernetes_cluster_role_binding" "alb_ingress_controller" {
  depends_on = [null_resource.update_kubeconfig]
  metadata {
    name = "alb-ingress-controller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "alb-ingress-controller"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "alb-ingress-controller"
    namespace = "kube-system"
  }
}

resource "kubernetes_service_account" "alb_ingress_controller" {
  depends_on = [null_resource.update_kubeconfig]
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
  }
}

