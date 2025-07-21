# Inception Project

Ce projet met en place une infrastructure Docker complète avec NGINX, WordPress et MariaDB selon les spécifications du projet Inception de 42.

## Architecture

- **NGINX**: Serveur web avec SSL/TLS (port 443 uniquement)
- **WordPress**: CMS avec PHP-FPM
- **MariaDB**: Base de données
- **Volumes persistants**: Données WordPress et MariaDB
- **Réseau Docker**: Communication entre conteneurs
- **Secrets Docker**: Gestion sécurisée des mots de passe

## Prérequis

- Docker et Docker Compose installés
- Droits sudo pour créer les dossiers de données
- Modification du fichier /etc/hosts (voir ci-dessous)

## Configuration du domaine

Ajoutez cette ligne à votre fichier `/etc/hosts` :

```
127.0.0.1 mochamsa.42.fr
```

## Structure du projet

```
inception/
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   │   ├── nginx.conf
        │   │   └── default.conf
        │   └── tools/
        │       └── start_nginx.sh
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   ├── conf/
        │   │   └── www.conf
        │   └── tools/
        │       └── wp_setup.sh
        └── mariadb/
            ├── Dockerfile
            ├── .dockerignore
            ├── conf/
            │   └── 50-server.cnf
            └── tools/
                └── init_db.sh
```

## Utilisation

### Démarrage complet
```bash
make
```

### Commandes disponibles

- `make build` - Construire les images Docker
- `make up` - Démarrer les conteneurs
- `make down` - Arrêter les conteneurs
- `make clean` - Nettoyer les images Docker
- `make fclean` - Nettoyage complet (incluant les données)
- `make re` - Reconstruire tout
- `make logs` - Afficher les logs
- `make status` - Afficher le statut des conteneurs
- `make help` - Afficher l'aide

## Accès

Une fois démarré, l'application est accessible à :
- **URL**: https://mochamsa.42.fr
- **Utilisateur Admin**: wpadmin
- **Mot de passe Admin**: (voir secrets/credentials.txt)

## Volumes de données

Les données sont stockées dans :
- `/home/mochamsa/data/wordpress` - Fichiers WordPress
- `/home/mochamsa/data/mariadb` - Base de données MariaDB

## Sécurité

- Utilisation de TLS 1.2/1.3 uniquement
- Certificats SSL auto-signés
- Mots de passe stockés dans des secrets Docker
- Utilisateurs non-root dans les conteneurs
- Réseau Docker isolé

## Dépannage

### Vérifier les logs
```bash
make logs
```

### Vérifier le statut
```bash
make status
```

### Redémarrage complet
```bash
make re
```

### Problèmes de permissions
```bash
sudo chown -R $USER:$USER /home/mochamsa/data/
```

## Variables d'environnement

Voir le fichier `srcs/.env` pour toutes les variables configurables.

## Notes importantes

- Les conteneurs redémarrent automatiquement en cas de crash
- Aucun mot de passe n'est présent dans les Dockerfiles
- Utilisation de l'avant-dernière version stable de Debian
- Respect des bonnes pratiques Docker (PID 1, pas de hacks)
