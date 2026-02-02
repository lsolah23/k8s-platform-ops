terraform {
  required_providers {
    helm = { 
      source = "hashicorp/helm" 
      version = "~> 2.0" 
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Este es el que faltaba para que Terraform sepa hablar directo con el cluster
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kubernetes-admin@kubernetes"
}

# Este es el que usa Helm para instalar los paquetes
provider "helm" {
  kubernetes { 
    config_path    = "~/.kube/config"
    config_context = "kubernetes-admin@kubernetes"
  }
}

# --- Recursos ---

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
}

resource "helm_release" "monitoring" {
  name             = "obs"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  create_namespace = true
}