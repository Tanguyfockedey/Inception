# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: tafocked <tafocked@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/06/21 23:24:51 by tafocked          #+#    #+#              #
#    Updated: 2025/07/04 16:51:15 by tafocked         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

all: up

up:
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
	
.PHONY: all up down logs clean