
if [ $# -eq 1 ]; then
    DOCKER_NAME=$1
else
    DOCKER_NAME="${USER}_deep_docker"
fi
docker stop $DOCKER_NAME
docker rm $DOCKER_NAME

