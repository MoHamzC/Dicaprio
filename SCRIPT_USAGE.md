# 🚀 INCEPTION ALL-IN-ONE AUTOMATION SCRIPT

## 📖 Description
Ce script `inception_all.sh` automatise complètement votre projet Inception pour l'environnement 42. Il gère tout : vérifications, configuration, build, tests et monitoring.

## ⚡ Utilisation Ultra-Rapide

```bash
# Rendre exécutable (une seule fois)
chmod +x inception_all.sh

# Lancer le script
./inception_all.sh

# Choisir l'option 1 pour un setup automatique complet
```

## 🎯 Fonctionnalités

### 1️⃣ Setup Complet Automatique
- ✅ Vérification système (Docker, permissions, espace disque)
- ✅ Configuration automatique (.env, secrets, volumes)
- ✅ Build des images Docker
- ✅ Démarrage des services
- ✅ Tests de fonctionnement
- ✅ **TOUT EN UNE SEULE COMMANDE !**

### 2️⃣ Build et Démarrage Rapide
- 🔨 Build des images sans cache
- 🚀 Démarrage des 3 conteneurs
- ⏱️ Vérification automatique de l'état

### 3️⃣ Tests et Vérifications
- 🧪 Test MariaDB (connectivité, ping)
- 🧪 Test WordPress/PHP-FPM (configuration)
- 🧪 Test Nginx (configuration, SSL)
- 🧪 Test HTTPS (curl localhost)
- 🧪 Test base de données WordPress

### 4️⃣ Monitoring et Logs
- 📊 État des conteneurs
- 💻 Utilisation des ressources (CPU, RAM)
- 📁 Liste des volumes Docker
- 📝 Logs récents de tous les services

### 5️⃣ Nettoyage Intelligent
- 🛑 Arrêt des conteneurs uniquement
- 🧹 Nettoyage des images Docker
- 💥 Nettoyage complet avec confirmation

### 6️⃣ Diagnostic Automatique
- 🔍 Détection automatique des problèmes
- ⚠️ Vérification des ports, volumes, logs
- 💡 Solutions suggérées pour les problèmes courants

### 7️⃣ Aide Intégrée
- 📖 Documentation complète
- 🔧 Commandes manuelles disponibles
- 🌐 Informations d'accès au site

## 🎪 Menu Interactif

Le script affiche un menu coloré et interactif :

```
═══════════════════════════════════════
     MENU INCEPTION AUTOMATION
═══════════════════════════════════════
1) 🔧 Setup complet automatique
2) 🚀 Build et démarrage rapide
3) 🧪 Tests et vérifications
4) 📊 Monitoring et logs
5) 🧹 Nettoyage et reset
6) 🔍 Diagnostic de problèmes
7) ❓ Aide et documentation
0) 🚪 Quitter
```

## 🔧 Configuration Automatique

Le script crée automatiquement :

### Fichier `.env`
```bash
# Database Configuration
MYSQL_ROOT_PASSWORD=root_password_123
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_password_123

# WordPress Configuration
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=admin_password_123
WP_ADMIN_EMAIL=votre_login@student.42.fr
```

### Fichiers Secrets
- `srcs/secrets/db_root_password`
- `srcs/secrets/db_password`
- `srcs/secrets/credentials`

### Volumes Docker
- `inception_mariadb_data`
- `inception_wordpress_data`

## 🌐 Accès au Site

Après un setup réussi :
- **URL** : https://localhost
- **Admin** : wpadmin
- **Password** : admin_password_123

## 📊 Logs et Monitoring

Le script génère :
- `inception_setup.log` - Log principal du script
- `inception_errors.log` - Log des erreurs uniquement

## 🔍 Diagnostic Intégré

Le script vérifie automatiquement :
- ✅ Nombre de conteneurs actifs (3/3)
- ✅ Port 443 ouvert
- ✅ Présence des volumes Docker
- ✅ Erreurs dans les logs
- 💡 Suggestions de solutions

## 🆘 Solutions Communes

| Problème | Solution |
|----------|----------|
| Permission denied Docker | `newgrp docker` |
| Port 443 déjà utilisé | `sudo lsof -i :443` |
| Volumes corrompus | `make fclean && make` |
| Certificat SSL non fiable | Normal (certificat auto-signé) |
| MariaDB ne démarre pas | `docker-compose down -v && docker-compose build --no-cache` |
| Secrets non lisibles | Reconstruction complète nécessaire |

## 🎯 Parfait pour 42

- ❌ **Pas de sudo requis**
- ✅ Fonctionne dans l'environnement 42
- ✅ Volumes Docker nommés (pas de bind mounts)
- ✅ Configuration localhost automatique
- ✅ Gestion intelligente des permissions Docker

## 🏃‍♂️ One-Liner pour les Pressés

```bash
chmod +x inception_all.sh && ./inception_all.sh
```

Puis choisir l'option `1` et tout se fait automatiquement ! 🎉

---

**Astuce** : Le script sauvegarde automatiquement vos anciens fichiers de configuration avant de les remplacer, vous ne risquez rien ! 🛡️
