#!/bin/bash

# Script de déploiement automatique
set -e

echo "🚀 Déploiement Kollab sur Kubernetes..."

# Variables
NAMESPACE="kollab"
REGISTRY="ghcr.io"
REPO_NAME="${GITHUB_REPOSITORY:-local/kollab}"

# Vérifier que kubectl est configuré
if ! kubectl cluster-info &> /dev/null; then
    echo "❌ kubectl n'est pas configuré ou le cluster n'est pas accessible"
    exit 1
fi

# Créer le namespace s'il n'existe pas
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Appliquer les manifests Kubernetes
echo "📦 Application des manifests..."
kubectl apply -f k8s/

# Attendre que les pods soient prêts
echo "⏳ Attente des pods..."
kubectl wait --for=condition=ready pod -l app=backend -n $NAMESPACE --timeout=300s
kubectl wait --for=condition=ready pod -l app=frontend -n $NAMESPACE --timeout=300s

# Vérifier le statut
echo "✅ Statut des pods:"
kubectl get pods -n $NAMESPACE

echo "🎉 Déploiement terminé avec succès!"

# mod