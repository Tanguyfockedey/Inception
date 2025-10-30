# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tafocked <tafocked@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/21 23:24:51 by tafocked          #+#    #+#              #
#    Updated: 2025/10/30 18:42:25 by tafocked         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

restart: down clean up

up:
	mkdir -p /home/${USER}/data/DB
	mkdir -p /home/${USER}/data/WordPress
	@echo "Starting up the project..."
	@docker compose -f srcs/docker-compose.yml up --build -d

down:
	@echo "Stopping the project..."
	@docker compose -f srcs/docker-compose.yml down

logs:
	@echo "Displaying logs..."
	@docker compose -f srcs/docker-compose.yml logs -f

clean:
	@echo "Cleaning up the project..."
	@docker system prune -a --volumes -f
	@docker compose -f srcs/docker-compose.yml down --volumes --rmi all
	@rm -rf /home/${USER}/data

.PHONY: all up down logs clean