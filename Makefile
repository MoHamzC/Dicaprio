# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::   #
#    Makefile                                           :+:      :+:    :+:   #
#                                                     +:+ +:+         +:+     #
#    By: mochamsa <mochamsa@student.42.fr>          +#+  +:+       +#+        #
#                                                 +#+#+#+#+#+   +#+           #
#    Created: 2025/07/08 00:00:00 by mochamsa          #+#    #+#             #
#    Updated: 2025/07/08 00:00:00 by mochamsa         ###   ########.fr       #
#                                                                              #
# **************************************************************************** #

# Variables
COMPOSE_FILE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data
DOMAIN_NAME = $(USER).42.fr

# Colors for output
GREEN = \033[0;32m
YELLOW = \033[0;33m
RED = \033[0;31m
NC = \033[0m # No Color

.PHONY: all build up down clean fclean re logs status help localhost

all: build up

localhost:
	@echo "$(YELLOW)Configuring for localhost access...$(NC)"
	@cp srcs/requirements/nginx/conf/default_42.conf srcs/requirements/nginx/conf/default.conf
	@$(MAKE) build up
	@echo "$(GREEN)Access your site at: https://localhost$(NC)"

build:
	@echo "$(YELLOW)Building Docker images...$(NC)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@chmod 755 $(DATA_PATH) 2>/dev/null || true
	docker-compose -f $(COMPOSE_FILE) build

up:
	@echo "$(GREEN)Starting containers...$(NC)"
	docker-compose -f $(COMPOSE_FILE) up -d

down:
	@echo "$(RED)Stopping containers...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down

clean: down
	@echo "$(YELLOW)Cleaning Docker images...$(NC)"
	docker system prune -af

fclean: clean
	@echo "$(RED)Removing all data...$(NC)"
	docker-compose -f $(COMPOSE_FILE) down -v
	docker system prune -af --volumes
	rm -rf $(DATA_PATH)

re: fclean all

logs:
	docker-compose -f $(COMPOSE_FILE) logs -f

status:
	@echo "$(GREEN)Container status:$(NC)"
	docker-compose -f $(COMPOSE_FILE) ps

help:
	@echo "Available commands:"
	@echo "  $(GREEN)make build$(NC)     - Build Docker images"
	@echo "  $(GREEN)make up$(NC)        - Start containers"
	@echo "  $(GREEN)make down$(NC)      - Stop containers"
	@echo "  $(GREEN)make clean$(NC)     - Clean Docker images"
	@echo "  $(GREEN)make fclean$(NC)    - Full clean (including data)"
	@echo "  $(GREEN)make re$(NC)        - Rebuild everything"
	@echo "  $(GREEN)make logs$(NC)      - Show container logs"
	@echo "  $(GREEN)make status$(NC)    - Show container status"
	@echo "  $(GREEN)make localhost$(NC) - Configure for localhost access"
