DOCKER_NAME="${USER}_deep_docker"

docker start $DOCKER_NAME
docker exec -it -u ${USER} -e LINES=$(tput lines) -e COLUMNS=$(tput cols) $DOCKER_NAME /usr/bin/zsh 