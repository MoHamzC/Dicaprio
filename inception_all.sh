#!/bin/bash

# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::   #
#    inception_all.sh                                   :+:      :+:    :+:   #
#                                                     +:+ +:+         +:+     #
#    By: mochamsa <mochamsa@student.42.fr>          +#+  +:+       +#+        #
#                                                 +#+#+#+#+#+   +#+           #
#    Created: 2025/07/21 00:00:00 by assistant          #+#    #+#             #
#    Updated: 2025/07/21 00:00:00 by assistant         ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

# SCRIPT D'AUTOMATISATION COMPLET INCEPTION 42
# Ce script fait tout : vérification, configuration, build, test, monitoring

set -e  # Exit on any error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Global variables
USER=$(whoami)
PROJECT_DIR=$(pwd)
LOG_FILE="inception_setup.log"
ERROR_LOG="inception_errors.log"

# Functions
print_header() {
    echo -e "${BOLD}${CYAN}"
    echo "╔═══════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                           INCEPTION PROJECT - 42 AUTOMATION                      ║"
    echo "║                                                                                   ║"
    echo "║  Ce script automatise complètement votre projet Inception :                      ║"
    echo "║  ✅ Vérifications système                                                        ║"
    echo "║  ✅ Configuration automatique                                                    ║"
    echo "║  ✅ Build des images Docker                                                      ║"
    echo "║  ✅ Tests de fonctionnement                                                      ║"
    echo "║  ✅ Monitoring et logs                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

error_log() {
    echo -e "${RED}ERROR: $1${NC}" | tee -a "$ERROR_LOG"
}

success_log() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$LOG_FILE"
}

warning_log() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$LOG_FILE"
}

info_log() {
    echo -e "${BLUE}ℹ️  $1${NC}" | tee -a "$LOG_FILE"
}

# Menu principal
show_menu() {
    echo -e "${BOLD}${PURPLE}═══════════════════════════════════════${NC}"
    echo -e "${BOLD}${PURPLE}     MENU INCEPTION AUTOMATION${NC}"
    echo -e "${BOLD}${PURPLE}═══════════════════════════════════════${NC}"
    echo -e "${GREEN}1)${NC} 🔧 Setup complet automatique"
    echo -e "${GREEN}2)${NC} 🚀 Build et démarrage rapide"
    echo -e "${GREEN}3)${NC} 🧪 Tests et vérifications"
    echo -e "${GREEN}4)${NC} 📊 Monitoring et logs"
    echo -e "${GREEN}5)${NC} 🧹 Nettoyage et reset"
    echo -e "${GREEN}6)${NC} 🔍 Diagnostic de problèmes"
    echo -e "${GREEN}7)${NC} ❓ Aide et documentation"
    echo -e "${RED}0)${NC} 🚪 Quitter"
    echo -e "${PURPLE}═══════════════════════════════════════${NC}"
}

# Vérifications système
check_system() {
    log "${CYAN}▶️  VÉRIFICATION DU SYSTÈME${NC}"
    
    # Vérifier Docker
    if ! command -v docker &> /dev/null; then
        error_log "Docker n'est pas installé"
        return 1
    fi
    success_log "Docker installé"
    
    # Vérifier Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        error_log "Docker Compose n'est pas installé"
        return 1
    fi
    success_log "Docker Compose installé"
    
    # Vérifier les permissions Docker
    if ! docker ps &> /dev/null; then
        warning_log "Problème de permissions Docker détecté"
        info_log "Tentative de correction avec newgrp docker..."
        exec newgrp docker
    fi
    success_log "Permissions Docker OK"
    
    # Vérifier l'espace disque
    local available_space=$(df -h . | awk 'NR==2{print $4}' | sed 's/G//')
    if [ "${available_space%G*}" -lt 5 ]; then
        warning_log "Espace disque faible (${available_space}G disponible)"
    else
        success_log "Espace disque suffisant (${available_space}G)"
    fi
    
    # Vérifier la structure du projet
    if [ ! -f "srcs/docker-compose.yml" ]; then
        error_log "Structure de projet invalide - docker-compose.yml manquant"
        return 1
    fi
    success_log "Structure de projet valide"
}

# Configuration automatique
auto_setup() {
    log "${CYAN}▶️  CONFIGURATION AUTOMATIQUE${NC}"
    
    # Backup des fichiers existants
    if [ -f "srcs/.env" ]; then
        cp srcs/.env srcs/.env.backup
        info_log "Sauvegarde .env créée"
    fi
    
    # Créer le fichier .env
    cat > srcs/.env << EOF
# Database Configuration
MYSQL_ROOT_PASSWORD=root_password_123
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_password_123

# WordPress Configuration
WP_ADMIN_USER=wpadmin
WP_ADMIN_PASSWORD=admin_password_123
WP_ADMIN_EMAIL=${USER}@student.42.fr
WP_USER=wpuser
WP_USER_PASSWORD=user_password_123
WP_USER_EMAIL=${USER}_user@student.42.fr

# Domain Configuration
DOMAIN_NAME=${USER}.42.fr
EOF
    
    success_log "Fichier .env créé"
    
    # Créer les dossiers secrets
    mkdir -p srcs/secrets
    
    # Créer les fichiers secrets (sans extension .txt)
    echo "root_password_123" > srcs/secrets/db_root_password
    echo "wp_password_123" > srcs/secrets/db_password
    cat > srcs/secrets/credentials << EOF
Admin User: wpadmin
Admin Password: admin_password_123
User: wpuser
User Password: user_password_123
EOF
    
    chmod 600 srcs/secrets/*
    success_log "Secrets configurés"
    
    # Vérifier que tous les fichiers secrets existent
    local missing_files=()
    [ ! -f "srcs/secrets/db_root_password" ] && missing_files+=("db_root_password")
    [ ! -f "srcs/secrets/db_password" ] && missing_files+=("db_password")
    [ ! -f "srcs/secrets/credentials" ] && missing_files+=("credentials")
    
    if [ ${#missing_files[@]} -eq 0 ]; then
        success_log "Tous les fichiers secrets sont présents"
    else
        error_log "Fichiers secrets manquants: ${missing_files[*]}"
        return 1
    fi
    
    # Créer les volumes Docker nommés
    docker volume create inception_mariadb_data || true
    docker volume create inception_wordpress_data || true
    success_log "Volumes Docker créés"
}

# Build et démarrage
build_and_start() {
    log "${CYAN}▶️  BUILD ET DÉMARRAGE${NC}"
    
    # Nettoyer les anciens conteneurs
    info_log "Nettoyage des anciens conteneurs..."
    docker-compose -f srcs/docker-compose.yml down -v || true
    
    # Build des images
    info_log "Build des images Docker..."
    if docker-compose -f srcs/docker-compose.yml build --no-cache; then
        success_log "Images construites avec succès"
    else
        error_log "Erreur lors du build des images"
        return 1
    fi
    
    # Démarrage des services
    info_log "Démarrage des services..."
    if docker-compose -f srcs/docker-compose.yml up -d; then
        success_log "Services démarrés"
    else
        error_log "Erreur lors du démarrage des services"
        return 1
    fi
    
    # Attendre que les services soient prêts
    info_log "Attente de la disponibilité des services..."
    sleep 30
    
    # Vérifier l'état des conteneurs
    if [ "$(docker-compose -f srcs/docker-compose.yml ps -q | wc -l)" -eq 3 ]; then
        success_log "Tous les conteneurs sont actifs"
    else
        warning_log "Certains conteneurs ne sont pas actifs"
    fi
}

# Tests de fonctionnement
run_tests() {
    log "${CYAN}▶️  TESTS DE FONCTIONNEMENT${NC}"
    
    # Test de connectivité MariaDB
    info_log "Test MariaDB..."
    if docker exec mariadb mysqladmin ping -h localhost --silent; then
        success_log "MariaDB fonctionne"
    else
        error_log "MariaDB ne répond pas"
    fi
    
    # Test PHP-FPM WordPress
    info_log "Test WordPress/PHP-FPM..."
    if docker exec wordpress php-fpm -t; then
        success_log "PHP-FPM configuration OK"
    else
        warning_log "Problème de configuration PHP-FPM"
    fi
    
    # Test Nginx
    info_log "Test Nginx..."
    if docker exec nginx nginx -t; then
        success_log "Nginx configuration OK"
    else
        error_log "Erreur de configuration Nginx"
    fi
    
    # Test de connectivité HTTP
    info_log "Test de connectivité HTTP..."
    if curl -k -s https://localhost > /dev/null; then
        success_log "Site accessible via HTTPS"
    else
        warning_log "Site non accessible via HTTPS"
    fi
    
    # Test de la base de données
    info_log "Test de la base de données WordPress..."
    if docker exec mariadb mysql -u wp_user -pwp_password_123 -e "USE wordpress; SHOW TABLES;" > /dev/null 2>&1; then
        success_log "Base de données WordPress accessible"
    else
        warning_log "Problème d'accès à la base de données"
    fi
}

# Monitoring et logs
monitoring() {
    log "${CYAN}▶️  MONITORING ET LOGS${NC}"
    
    echo -e "${BOLD}${PURPLE}État des conteneurs:${NC}"
    docker-compose -f srcs/docker-compose.yml ps
    
    echo -e "\n${BOLD}${PURPLE}Utilisation des ressources:${NC}"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}"
    
    echo -e "\n${BOLD}${PURPLE}Volumes Docker:${NC}"
    docker volume ls | grep inception
    
    echo -e "\n${BOLD}${PURPLE}Logs récents (dernières 50 lignes):${NC}"
    echo -e "${YELLOW}=== NGINX ===${NC}"
    docker-compose -f srcs/docker-compose.yml logs --tail=20 nginx
    
    echo -e "${YELLOW}=== WORDPRESS ===${NC}"
    docker-compose -f srcs/docker-compose.yml logs --tail=20 wordpress
    
    echo -e "${YELLOW}=== MARIADB ===${NC}"
    docker-compose -f srcs/docker-compose.yml logs --tail=20 mariadb
}

# Nettoyage
cleanup() {
    log "${CYAN}▶️  NETTOYAGE${NC}"
    
    echo -e "${YELLOW}Que voulez-vous nettoyer ?${NC}"
    echo "1) Arrêter les conteneurs seulement"
    echo "2) Nettoyer les images Docker"
    echo "3) Nettoyer complètement (DANGER: perte des données)"
    read -p "Votre choix (1-3): " choice
    
    case $choice in
        1)
            docker-compose -f srcs/docker-compose.yml down
            success_log "Conteneurs arrêtés"
            ;;
        2)
            docker-compose -f srcs/docker-compose.yml down
            docker system prune -f
            success_log "Images nettoyées"
            ;;
        3)
            read -p "⚠️  ATTENTION: Cela supprimera toutes les données ! Continuer ? (y/N): " confirm
            if [[ $confirm == [yY] ]]; then
                docker-compose -f srcs/docker-compose.yml down -v
                docker system prune -af --volumes
                docker volume rm inception_mariadb_data inception_wordpress_data 2>/dev/null || true
                success_log "Nettoyage complet effectué"
            else
                info_log "Nettoyage annulé"
            fi
            ;;
        *)
            warning_log "Choix invalide"
            ;;
    esac
}

# Diagnostic de problèmes
diagnostic() {
    log "${CYAN}▶️  DIAGNOSTIC DE PROBLÈMES${NC}"
    
    echo -e "${BOLD}${YELLOW}Diagnostic automatique en cours...${NC}"
    
    # Vérifier les conteneurs
    local running_containers=$(docker-compose -f srcs/docker-compose.yml ps -q | wc -l)
    if [ "$running_containers" -ne 3 ]; then
        warning_log "Nombre de conteneurs incorrect ($running_containers/3)"
        docker-compose -f srcs/docker-compose.yml ps
    fi
    
    # Vérifier les ports
    if ss -tuln | grep -q ":443"; then
        success_log "Port 443 (HTTPS) ouvert"
    else
        error_log "Port 443 non disponible"
    fi
    
    # Vérifier les volumes
    if docker volume ls | grep -q "inception_wordpress_data\|inception_mariadb_data"; then
        success_log "Volumes Docker présents"
    else
        warning_log "Volumes Docker manquants"
    fi
    
    # Vérifier les logs d'erreur
    if docker-compose -f srcs/docker-compose.yml logs | grep -i error; then
        warning_log "Erreurs trouvées dans les logs (voir ci-dessus)"
    else
        success_log "Aucune erreur majeure dans les logs"
    fi
    
    # Solutions communes
    echo -e "\n${BOLD}${PURPLE}Solutions communes:${NC}"
    echo -e "${YELLOW}• Permission denied sur Docker:${NC} newgrp docker"
    echo -e "${YELLOW}• Port déjà utilisé:${NC} sudo lsof -i :443"
    echo -e "${YELLOW}• Volumes corrompus:${NC} make fclean && make"
    echo -e "${YELLOW}• Certificat SSL non fiable:${NC} Normal pour un certificat auto-signé"
}

# Documentation et aide
show_help() {
    log "${CYAN}▶️  AIDE ET DOCUMENTATION${NC}"
    
    echo -e "${BOLD}${GREEN}🚀 DÉMARRAGE RAPIDE${NC}"
    echo -e "1. Exécuter: ${YELLOW}./inception_all.sh${NC}"
    echo -e "2. Choisir l'option 1 (Setup complet)"
    echo -e "3. Accéder au site: ${CYAN}https://localhost${NC}"
    
    echo -e "\n${BOLD}${GREEN}🔧 COMMANDES MANUELLES${NC}"
    echo -e "${YELLOW}make build${NC}      - Construire les images"
    echo -e "${YELLOW}make up${NC}         - Démarrer les services"
    echo -e "${YELLOW}make down${NC}       - Arrêter les services"
    echo -e "${YELLOW}make logs${NC}       - Voir les logs"
    echo -e "${YELLOW}make status${NC}     - État des conteneurs"
    echo -e "${YELLOW}make fclean${NC}     - Nettoyage complet"
    
    echo -e "\n${BOLD}${GREEN}🌐 ACCÈS AU SITE${NC}"
    echo -e "URL: ${CYAN}https://localhost${NC}"
    echo -e "Admin: ${YELLOW}wpadmin${NC}"
    echo -e "Password: ${YELLOW}admin_password_123${NC}"
    
    echo -e "\n${BOLD}${GREEN}📁 FICHIERS IMPORTANTS${NC}"
    echo -e "${YELLOW}srcs/.env${NC}                 - Variables d'environnement"
    echo -e "${YELLOW}srcs/secrets/credentials${NC}  - Identifiants de connexion"
    echo -e "${YELLOW}$LOG_FILE${NC}                 - Log de ce script"
    
    echo -e "\n${BOLD}${GREEN}🐛 EN CAS DE PROBLÈME${NC}"
    echo -e "1. Utiliser l'option 6 (Diagnostic)"
    echo -e "2. Vérifier les logs: ${YELLOW}make logs${NC}"
    echo -e "3. Redémarrer: ${YELLOW}make re${NC}"
}

# Fonction principale
main() {
    # Initialisation
    clear
    print_header
    
    # Créer les fichiers de log
    > "$LOG_FILE"
    > "$ERROR_LOG"
    
    while true; do
        show_menu
        read -p "$(echo -e ${CYAN}"Choisissez une option (0-7): "${NC})" choice
        
        case $choice in
            1)
                log "${BOLD}${GREEN}=== SETUP COMPLET AUTOMATIQUE ===${NC}"
                check_system && auto_setup && build_and_start && run_tests
                echo -e "\n${BOLD}${GREEN}🎉 Setup terminé ! Accédez au site: https://localhost${NC}"
                ;;
            2)
                log "${BOLD}${GREEN}=== BUILD ET DÉMARRAGE RAPIDE ===${NC}"
                build_and_start
                ;;
            3)
                log "${BOLD}${GREEN}=== TESTS ET VÉRIFICATIONS ===${NC}"
                run_tests
                ;;
            4)
                log "${BOLD}${GREEN}=== MONITORING ET LOGS ===${NC}"
                monitoring
                ;;
            5)
                log "${BOLD}${GREEN}=== NETTOYAGE ET RESET ===${NC}"
                cleanup
                ;;
            6)
                log "${BOLD}${GREEN}=== DIAGNOSTIC DE PROBLÈMES ===${NC}"
                diagnostic
                ;;
            7)
                show_help
                ;;
            0)
                log "${GREEN}Au revoir ! 👋${NC}"
                exit 0
                ;;
            *)
                warning_log "Option invalide. Veuillez choisir entre 0 et 7."
                ;;
        esac
        
        echo -e "\n${PURPLE}Appuyez sur Entrée pour continuer...${NC}"
        read
        clear
    done
}

# Vérifier que nous sommes dans le bon répertoire
if [ ! -f "Makefile" ] || [ ! -d "srcs" ]; then
    error_log "Ce script doit être exécuté depuis le dossier racine du projet Inception"
    exit 1
fi

# Lancement du script
main "$@"
