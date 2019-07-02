DOCKER_NAME="${USER}_deep_docker_tmp-caffe"

nvidia-docker start $DOCKER_NAME
nvidia-docker exec -it -u ${USER} -e LINES=$(tput lines) -e COLUMNS=$(tput cols) $DOCKER_NAME /usr/bin/zsh 
