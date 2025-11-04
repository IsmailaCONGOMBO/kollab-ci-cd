# Guide de Déploiement Docker - Kollab

Ce guide explique comment conteneuriser et lancer l'application Kollab avec Docker.

## 📋 Prérequis

- Docker Desktop installé (version 20.10+)
- Docker Compose installé (version 2.0+)
- Au moins 4GB de RAM disponible

## 🏗️ Architecture

L'application est composée de 4 services :

1. **MySQL** - Base de données (port 3306)
2. **Backend Laravel** - API REST (port 8000)
3. **Frontend Next.js** - Interface utilisateur (port 3000)
4. **phpMyAdmin** - Gestion de la base de données (port 8080)

## 🚀 Démarrage Rapide

### 1. Construire et démarrer tous les services

```bash
docker-compose up -d --build
```

### 2. Vérifier que les services sont en cours d'exécution

```bash
docker-compose ps
```

### 3. Accéder à l'application

- **Frontend** : http://localhost:3000
- **Backend API** : http://localhost:8000
- **phpMyAdmin** : http://localhost:8080

## 🛠️ Commandes Utiles

### Voir les logs

```bash
# Tous les services
docker-compose logs -f

# Service spécifique
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql
```

### Arrêter les services

```bash
docker-compose down
```

### Arrêter et supprimer les volumes (⚠️ supprime les données)

```bash
docker-compose down -v
```

### Redémarrer un service spécifique

```bash
docker-compose restart backend
docker-compose restart frontend
```

### Reconstruire un service après modification

```bash
docker-compose up -d --build backend
docker-compose up -d --build frontend
```

### Exécuter des commandes dans un conteneur

```bash
# Laravel artisan
docker-compose exec backend php artisan migrate
docker-compose exec backend php artisan db:seed
docker-compose exec backend php artisan cache:clear

# Accéder au shell du conteneur
docker-compose exec backend bash
docker-compose exec frontend sh
```

## 🔧 Configuration

### Variables d'environnement

Les variables d'environnement sont définies dans :
- `docker-compose.yml` pour la configuration des services
- `.env.docker` pour les valeurs partagées

### Personnalisation des ports

Pour changer les ports, modifiez le fichier `docker-compose.yml` :

```yaml
services:
  backend:
    ports:
      - "8000:80"  # Changez 8000 par le port souhaité
  
  frontend:
    ports:
      - "3000:3000"  # Changez 3000 par le port souhaité
```

## 🗄️ Base de Données

### Connexion à MySQL

- **Host** : localhost (ou mysql depuis un conteneur)
- **Port** : 3306
- **Database** : kollab
- **Username** : kollab_user
- **Password** : kollab_password
- **Root Password** : root_password

### Sauvegarder la base de données

```bash
docker-compose exec mysql mysqldump -u root -proot_password kollab > backup.sql
```

### Restaurer la base de données

```bash
docker-compose exec -T mysql mysql -u root -proot_password kollab < backup.sql
```

## 🐛 Dépannage

### Les conteneurs ne démarrent pas

```bash
# Vérifier les logs
docker-compose logs

# Reconstruire sans cache
docker-compose build --no-cache
docker-compose up -d
```

### Erreur de connexion à la base de données

```bash
# Vérifier que MySQL est prêt
docker-compose exec mysql mysqladmin ping -h localhost

# Redémarrer le backend
docker-compose restart backend
```

### Problèmes de permissions (Linux/Mac)

```bash
# Donner les bonnes permissions au dossier storage
sudo chown -R $USER:$USER Kollab/storage
sudo chmod -R 775 Kollab/storage
```

### Nettoyer Docker

```bash
# Supprimer les conteneurs arrêtés
docker container prune

# Supprimer les images non utilisées
docker image prune

# Nettoyer tout (⚠️ attention)
docker system prune -a
```

## 📦 Production

Pour un déploiement en production :

1. Modifiez les mots de passe dans `docker-compose.yml`
2. Activez HTTPS avec un reverse proxy (nginx, traefik)
3. Configurez les sauvegardes automatiques
4. Utilisez des volumes nommés pour la persistance
5. Configurez les limites de ressources

### Exemple avec nginx reverse proxy

Créez un fichier `docker-compose.prod.yml` :

```yaml
version: '3.8'

services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    depends_on:
      - backend
      - frontend
```

## 📝 Notes

- Les données MySQL sont persistées dans un volume Docker nommé `mysql_data`
- Les logs Laravel sont dans `Kollab/storage/logs`
- Le frontend est optimisé pour la production avec Next.js standalone mode

## 🆘 Support

Pour plus d'informations :
- Documentation Docker : https://docs.docker.com
- Documentation Laravel : https://laravel.com/docs
- Documentation Next.js : https://nextjs.org/docs
