# 🚀 Guide de Démarrage Rapide - Docker

## ✅ Checklist avant de lancer

- [ ] Docker Desktop est installé et lancé
- [ ] Les ports 3000, 3306, 8000 et 8080 sont disponibles
- [ ] Vous êtes à la racine du projet (`Travaux-Groupe4/projet`)

## 📝 Étapes de lancement

### 1. Vérifier que vous êtes au bon endroit

```bash
# Vous devez être dans le dossier contenant docker-compose.yml
cd c:\Users\somma\Desktop\Travaux-Groupe4\projet
```

### 2. Construire et lancer tous les conteneurs

```bash
docker-compose up -d --build
```

Cette commande va :
- ✅ Construire l'image Docker du backend Laravel
- ✅ Construire l'image Docker du frontend Next.js
- ✅ Télécharger l'image MySQL 8.0
- ✅ Télécharger l'image phpMyAdmin
- ✅ Créer le réseau Docker
- ✅ Démarrer tous les services

**⏱️ Temps estimé : 5-10 minutes** (selon votre connexion internet)

### 3. Vérifier que tout fonctionne

```bash
# Voir l'état des conteneurs
docker-compose ps

# Voir les logs en temps réel
docker-compose logs -f
```

Vous devriez voir :
```
kollab-mysql       Up (healthy)
kollab-backend     Up
kollab-frontend    Up
kollab-phpmyadmin  Up
```

### 4. Accéder à l'application

Ouvrez votre navigateur :

- **Frontend (Next.js)** : http://localhost:3000
- **Backend API (Laravel)** : http://localhost:8000
- **phpMyAdmin** : http://localhost:8080
  - Utilisateur : `root`
  - Mot de passe : `root_password`

## 🛑 Arrêter l'application

```bash
# Arrêter tous les conteneurs
docker-compose down

# Arrêter ET supprimer les données (⚠️ attention)
docker-compose down -v
```

## 🔄 Redémarrer après modifications

### Si vous modifiez le code backend (Laravel)

```bash
docker-compose up -d --build backend
```

### Si vous modifiez le code frontend (Next.js)

```bash
docker-compose up -d --build frontend
```

### Si vous modifiez docker-compose.yml

```bash
docker-compose down
docker-compose up -d
```

## 🐛 Problèmes courants

### ❌ Port déjà utilisé

**Erreur** : `Bind for 0.0.0.0:3000 failed: port is already allocated`

**Solution** :
```bash
# Trouver le processus qui utilise le port
netstat -ano | findstr :3000

# Tuer le processus (remplacer PID par le numéro trouvé)
taskkill /PID <PID> /F
```

### ❌ Docker Desktop n'est pas lancé

**Erreur** : `Cannot connect to the Docker daemon`

**Solution** : Lancez Docker Desktop et attendez qu'il soit complètement démarré

### ❌ Erreur de connexion à la base de données

**Solution** :
```bash
# Attendre que MySQL soit prêt (peut prendre 30-60 secondes)
docker-compose logs mysql

# Redémarrer le backend une fois MySQL prêt
docker-compose restart backend
```

### ❌ Le frontend ne se connecte pas au backend

**Solution** : Vérifiez que l'URL de l'API est correcte dans `docker-compose.yml` :
```yaml
frontend:
  environment:
    NEXT_PUBLIC_API_URL: http://localhost:8000/api
```

## 📊 Commandes utiles

```bash
# Voir les logs d'un service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql

# Exécuter une commande dans un conteneur
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan db:seed
docker-compose exec backend php artisan cache:clear

# Accéder au shell d'un conteneur
docker-compose exec backend bash
docker-compose exec frontend sh

# Voir l'utilisation des ressources
docker stats

# Nettoyer Docker (libérer de l'espace)
docker system prune -a
```

## 🎯 Prochaines étapes

Une fois l'application lancée :

1. ✅ Vérifiez que le frontend s'affiche sur http://localhost:3000
2. ✅ Testez l'API backend sur http://localhost:8000
3. ✅ Connectez-vous à phpMyAdmin pour voir la base de données
4. ✅ Vérifiez les logs pour détecter d'éventuelles erreurs

## 📚 Documentation complète

Pour plus de détails, consultez `DOCKER_README.md`
