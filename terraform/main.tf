# 1. Namespace aislado para ArgoCD
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
}

# 2. Namespace aislado para el stack de Monitoreo (Prometheus, Grafana, Alertmanager)
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

# 3. Instalación oficial de ArgoCD vía Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.53.1" # Versión estable de producción
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  set {
    name  = "server.modules.dex.enabled"
    value = "false"
  }
}

# 4. Instalación del Stack de Monitoreo (Kube-Prometheus-Stack)
resource "helm_release" "prometheus_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = "56.6.2" # Incluye Prometheus, Grafana y Alertmanager integrados
  namespace  = kubernetes_namespace.monitoring.metadata[0].name

  # Habilitamos que Alertmanager escuche los recursos tipo AlertmanagerConfig que creamos
  set {
    name  = "alertmanager.alertmanagerSpec.alertmanagerConfigSelectorConfig.matchExpressions[0].key"
    value = "release"
  }
  set {
    name  = "alertmanager.alertmanagerSpec.alertmanagerConfigSelectorConfig.matchExpressions[0].operator"
    value = "Exists"
  }
}