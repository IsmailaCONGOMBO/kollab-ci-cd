# 🚀 Kollab - Infrastructure DevOps Complète

## 📋 Vue d'ensemble

**Kollab** est une application de gestion collaborative avec une infrastructure DevOps moderne incluant :
- 🐳 **Conteneurisation** Docker
- ☸️ **Orchestration** Kubernetes  
- 🔄 **Pipeline CI/CD** GitHub Actions
- 📊 **Supervision** Prometheus + Grafana

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Repository    │    │   Repository    │    │   Repository    │
│  k13lucien/     │    │  k13lucien/     │    │ IsmailaCONGOMBO/│
│    Kollab       │    │ kollab-front    │    │  kollab-ci-cd   │
│   (Backend)     │    │  (Frontend)     │    │ (DevOps/CI/CD)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────▼─────────────┐
                    │     GitHub Actions        │
                    │   Pipeline CI/CD Auto     │
                    └─────────────┬─────────────┘
                                 │
                    ┌─────────────▼─────────────┐
                    │    Docker Images          │
                    │ ghcr.io/.../backend       │
                    │ ghcr.io/.../frontend      │
                    └─────────────┬─────────────┘
                                 │
                    ┌─────────────▼─────────────┐
                    │     Kubernetes            │
                    │  Backend + Frontend       │
                    │  + MySQL + Monitoring     │
                    └───────────────────────────┘
```

## 🛠️ Prérequis

### Logiciels requis
- **Docker Desktop** (avec Kubernetes activé)
- **Minikube** (alternative à Docker Desktop)
- **kubectl** (client Kubernetes)
- **Git**

### Installation rapide
```bash
# Windows (avec Chocolatey)
choco install docker-desktop minikube kubernetes-cli git

# macOS (avec Homebrew)
brew install docker minikube kubectl git

# Linux (Ubuntu/Debian)
sudo apt update
sudo apt install docker.io git
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## 🚀 Démarrage rapide

### 1. Cloner le repository DevOps
```bash
git clone https://github.com/IsmailaCONGOMBO/kollab-ci-cd.git
cd kollab-ci-cd
```

### 2. Démarrer l'environnement local avec Docker
```bash
# Cloner les repositories de l'application
git clone https://github.com/k13lucien/Kollab.git
git clone https://github.com/k13lucien/kollab-front.git

# Démarrer avec Docker Compose
docker-compose up -d

# Vérifier que tout fonctionne
docker-compose ps
```

**Accès application** :
- **Frontend** : http://localhost:3000
- **Backend** : http://localhost:8000  
- **phpMyAdmin** : http://localhost:8080
- **MySQL** : localhost:3306

### 3. Déployer sur Kubernetes

#### Démarrer Kubernetes
```bash
# Avec minikube
minikube start

# Ou activer Kubernetes dans Docker Desktop
# Settings → Kubernetes → Enable Kubernetes
```

#### Déployer l'application
```bash
# Appliquer tous les manifests Kubernetes
kubectl apply -f k8s/

# Vérifier le déploiement
kubectl get pods -n kollab
kubectl get services -n kollab
```

#### Accéder aux services
```bash
# Backend
minikube service backend-lb -n kollab

# Frontend  
minikube service frontend-lb -n kollab

# Ou via ingress (ajouter au fichier hosts)
echo "$(minikube ip) kollab.local" >> /etc/hosts
# Puis accéder à http://kollab.local
```

## 📊 Supervision avec Prometheus + Grafana

### Accéder aux interfaces de monitoring
```bash
# Prometheus (métriques)
minikube service prometheus -n kollab

# Grafana (dashboards)
minikube service grafana -n kollab
```

### Configuration Grafana
1. **Connexion** : admin / admin123
2. **Ajouter Prometheus** : 
   - Configuration → Data Sources → Add Prometheus
   - URL : `http://prometheus:9090`
3. **Créer dashboards** avec ces métriques :
   ```promql
   # Utilisateurs application
   kollab_users_total
   
   # Statut services
   kollab_backend_up
   kollab_frontend_up
   
   # CPU système
   100 - (avg(rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
   
   # Pods Kubernetes
   kube_pod_status_ready{namespace="kollab"}
   ```

## 🔄 Pipeline CI/CD

### Comment ça fonctionne
1. **Push sur main** → Déclenche GitHub Actions
2. **Clone automatique** des repositories backend et frontend
3. **Build des images** Docker
4. **Push vers GitHub Container Registry**
5. **Génération des manifests** Kubernetes
6. **Artifacts disponibles** pour téléchargement

### Voir la pipeline en action
1. Aller sur https://github.com/IsmailaCONGOMBO/kollab-ci-cd
2. Cliquer sur **Actions**
3. Voir les workflows "Build and Deploy"

### Utiliser les images CI/CD
```bash
# Utiliser les images buildées par la CI/CD
docker pull ghcr.io/ismailacongombo/kollab/backend:latest
docker pull ghcr.io/ismailacongombo/kollab/frontend:latest

# Ou modifier les manifests K8s pour utiliser ces images
# (déjà configuré dans k8s/backend-deployment.yaml)
```

## 🧪 Tests et validation

### Vérifier Docker
```bash
# Tester les services
curl http://localhost:8000  # Backend
curl http://localhost:3000  # Frontend

# Voir les logs
docker-compose logs backend
docker-compose logs frontend
```

### Vérifier Kubernetes
```bash
# Statut des pods
kubectl get pods -n kollab

# Logs des applications
kubectl logs deployment/backend -n kollab
kubectl logs deployment/frontend -n kollab

# Tester la connectivité
kubectl port-forward service/backend 8080:80 -n kollab
curl http://localhost:8080
```

### Vérifier la supervision
```bash
# Targets Prometheus (doivent être UP)
# Aller sur Prometheus → Status → Targets

# Métriques disponibles
# Tester ces requêtes dans Prometheus :
kollab_users_total
kollab_backend_up
node_cpu_seconds_total
```

## 🛠️ Dépannage

### Problèmes courants

#### Docker
```bash
# Redémarrer les services
docker-compose down && docker-compose up -d

# Nettoyer les volumes
docker-compose down -v
docker system prune -a
```

#### Kubernetes
```bash
# Redémarrer minikube
minikube stop && minikube start

# Réappliquer les manifests
kubectl delete namespace kollab
kubectl apply -f k8s/

# Voir les événements
kubectl get events -n kollab --sort-by='.lastTimestamp'
```

#### Accès aux services
```bash
# Si les services ne sont pas accessibles
minikube tunnel  # Dans un terminal séparé

# Vérifier les ports
kubectl get services -n kollab
```

## 📁 Structure du projet

```
kollab-ci-cd/
├── .github/workflows/     # Pipeline CI/CD GitHub Actions
│   └── build.yml         # Workflow principal
├── k8s/                  # Manifests Kubernetes
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   ├── mysql-statefulset.yaml
│   ├── prometheus.yaml
│   ├── grafana.yaml
│   └── ...
├── docker-compose.yml    # Configuration Docker locale
├── Kollab/              # Backend Laravel (cloné)
├── kollab-front/        # Frontend Next.js (cloné)
└── README.md           # Ce fichier
```

## 🎯 Métriques surveillées

### Application
- **Utilisateurs** : `kollab_users_total`
- **Sessions actives** : `kollab_active_sessions`
- **Statut services** : `kollab_backend_up`, `kollab_frontend_up`
- **Temps de réponse** : `kollab_response_time_seconds`

### Infrastructure
- **CPU** : `node_cpu_seconds_total`
- **Mémoire** : `node_memory_MemAvailable_bytes`
- **Pods K8s** : `kube_pod_status_ready`
- **Déploiements** : `kube_deployment_status_replicas`

## 🤝 Contribution

1. **Fork** le repository
2. **Créer une branche** : `git checkout -b feature/ma-feature`
3. **Commit** : `git commit -m "Add: ma feature"`
4. **Push** : `git push origin feature/ma-feature`
5. **Pull Request** vers `main`

## 📞 Support

- **Issues** : https://github.com/IsmailaCONGOMBO/kollab-ci-cd/issues
- **Documentation** : Ce README
- **Monitoring** : Grafana dashboards

---

**🎉 Félicitations ! Vous avez maintenant une infrastructure DevOps complète pour Kollab !**

*Développé avec ❤️ pour la collaboration moderne*