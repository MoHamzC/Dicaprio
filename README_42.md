# Inception Project - 42 Environment

Ce projet est adapté pour l'environnement 42 sans privilèges sudo.

## 🚀 Démarrage rapide

### Option 1 : Accès via localhost (Recommandé pour 42)
```bash
./setup_42.sh  # Lire les instructions
./setup.sh     # Configuration automatique
make localhost # Build et start avec localhost
```

### Option 2 : Accès via nom de domaine
```bash
./setup.sh
make
# Demandez à l'admin d'ajouter '127.0.0.1 [votre_login].42.fr' à /etc/hosts
```

## 📋 Prérequis vérifiés automatiquement

- ✅ Docker installé
- ✅ Docker Compose installé
- ✅ Utilisateur dans le groupe docker

Si docker n'est pas accessible, exécutez :
```bash
newgrp docker
```

## 🔧 Différences avec l'environnement standard

### Volumes Docker
- ❌ Pas de bind mounts vers /home/user/data
- ✅ Utilisation de volumes Docker nommés
- ✅ Données persistantes dans le système Docker

### DNS/Hosts
- ❌ Pas de modification de /etc/hosts
- ✅ Configuration pour localhost
- ✅ Support des deux domaines (localhost + [login].42.fr)

### Permissions
- ❌ Pas de sudo requis
- ✅ Fonctionnement complet en utilisateur normal
- ✅ Création automatique des dossiers necessaires

## 🌐 Accès au site

Après `make` ou `make localhost` :
- **URL** : https://localhost
- **Admin** : wpadmin  
- **Password** : voir `secrets/credentials.txt`

## 📊 Commandes de monitoring

```bash
make status   # État des conteneurs
make logs     # Logs en temps réel
docker ps     # Vue détaillée des conteneurs
docker volume ls  # Volumes créés
```

## 🔍 Résolution de problèmes

### Permission denied sur Docker
```bash
# Vérifier membership groupe docker
groups $USER

# Si pas dans docker group
newgrp docker
```

### Conteneur ne démarre pas
```bash
make logs
# Vérifier les logs d'erreur
```

### Certificat SSL non fiable
- C'est normal (certificat auto-signé)
- Cliquer "Avancé" puis "Continuer vers localhost"

### Volumes perdus après reboot
```bash
# Les volumes Docker sont persistants
docker volume ls
# Si vides, reconstruire :
make re
```

## 📁 Structure des données

```bash
# Volumes Docker (gérés automatiquement)
docker volume inspect inception_wordpress_data
docker volume inspect inception_mariadb_data

# Localisation physique
/var/lib/docker/volumes/inception_wordpress_data/_data
/var/lib/docker/volumes/inception_mariadb_data/_data
```

## 🧹 Nettoyage

```bash
make clean   # Images seulement
make fclean  # Tout + volumes
make re      # Reconstruction complète
```

## ⚠️ Notes importantes pour 42

1. **Pas de sudo** : Tout fonctionne en utilisateur normal
2. **Volumes nommés** : Pas de fichiers dans votre HOME
3. **Localhost** : Pas besoin de modifier /etc/hosts
4. **Persistance** : Données conservées entre redémarrages
5. **Conformité** : Respecte toutes les contraintes du sujet

## 🎯 Validation du projet

- ✅ 3 conteneurs séparés (nginx, wordpress, mariadb)
- ✅ Dockerfile personnalisés 
- ✅ Docker-compose avec réseau dédié
- ✅ Volumes persistants
- ✅ SSL/TLS uniquement
- ✅ Pas de mots de passe dans Dockerfiles
- ✅ Redémarrage automatique des conteneurs
- ✅ Images basées Debian (avant-dernière stable)
- ✅ Pas de "hacky patches"
