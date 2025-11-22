# 🔄 Workflows pour déclenchement automatique

## 📋 Instructions d'installation

### 1. Token GitHub requis

Créer un **Personal Access Token** avec les permissions :
- `repo` (accès complet aux repositories)
- `workflow` (déclencher les workflows)

**Étapes** :
1. GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Generate new token → Cocher `repo` et `workflow`
3. Copier le token généré

### 2. Ajouter le token aux repositories

#### Dans `k13lucien/Kollab` (Backend)
1. Repository → Settings → Secrets and variables → Actions
2. New repository secret :
   - **Name** : `DEVOPS_TOKEN`
   - **Value** : [votre token GitHub]

#### Dans `k13lucien/kollab-front` (Frontend)
1. Repository → Settings → Secrets and variables → Actions
2. New repository secret :
   - **Name** : `DEVOPS_TOKEN`
   - **Value** : [votre token GitHub]

### 3. Ajouter les workflows

#### Backend (`k13lucien/Kollab`)
Copier le contenu de `backend-trigger.yml` vers :
```
k13lucien/Kollab/.github/workflows/trigger-deploy.yml
```

#### Frontend (`k13lucien/kollab-front`)
Copier le contenu de `frontend-trigger.yml` vers :
```
k13lucien/kollab-front/.github/workflows/trigger-deploy.yml
```

## 🚀 Fonctionnement

### Déclencheurs automatiques
```
Backend Push → Trigger → DevOps CI/CD → Build & Deploy
Frontend Push → Trigger → DevOps CI/CD → Build & Deploy
DevOps Push → Direct → DevOps CI/CD → Build & Deploy
```

### Workflow complet
1. **Développeur** push sur `main` (backend ou frontend)
2. **Workflow trigger** s'exécute automatiquement
3. **API GitHub** envoie `repository_dispatch` au repo DevOps
4. **Pipeline DevOps** se déclenche avec `event_type` approprié
5. **Build & Deploy** automatique des nouvelles versions

### Logs et monitoring
- **Triggers** : Visibles dans Actions des repos backend/frontend
- **Déploiements** : Visibles dans Actions du repo DevOps
- **Payload** : Informations sur le commit, auteur, branche

## 🔧 Test de la configuration

### Test manuel
```bash
# Déclencher manuellement (pour test)
curl -X POST \
  -H "Authorization: token YOUR_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/IsmailaCONGOMBO/kollab-ci-cd/dispatches \
  -d '{"event_type":"backend_updated","client_payload":{"test":true}}'
```

### Vérification
1. Push un commit sur backend ou frontend
2. Vérifier dans Actions que le trigger s'exécute
3. Vérifier dans Actions DevOps que le build se déclenche
4. Confirmer que les images Docker sont mises à jour

## ⚠️ Points d'attention

- **Token sécurisé** : Ne jamais exposer le token dans le code
- **Permissions** : Le token doit avoir accès au repo DevOps
- **Rate limiting** : GitHub limite les API calls
- **Branches** : Configuré pour `main` uniquement

## 🎯 Avantages

✅ **Déploiement automatique** lors des modifications  
✅ **Temps réel** - déclenchement immédiat  
✅ **Traçabilité** complète des déploiements  
✅ **Architecture multi-repos** préservée  
✅ **Sécurisé** via tokens GitHub  
✅ **Logs centralisés** dans le repo DevOps