docker-compose-file = srcs/docker-compose.yml

all: up

creat_D_volume:
	mkdir -p /home/kali/data/mariadb /home/kali/data/wordpress

up: build creat_D_volume
	docker-compose -f $(docker-compose-file) up -d

build:
	docker-compose -f $(docker-compose-file) build

down:
	docker-compose -f $(docker-compose-file) down

re: down up

fclean: down 
	@if [ -n "$$(docker image ls -q)" ]; then \
		docker image rm -f $$(docker image ls -q); \
	fi
	docker system prune -f
	docker volume prune -f
	docker-compose -f $(docker-compose-file) down -v
	sudo rm -rf /home/kali/data