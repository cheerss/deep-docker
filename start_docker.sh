
VERSION="10.0-cudnn7-devel-ubuntu18.04"
DOCKER_NAME="${USER}_deep_docker_18.04"
DOCKER_USER="${USER}"
IMG="cheerss/deep-docker"
SHELL=/usr/bin/zsh

eval /usr/bin/docker run -it -d \
    -e DOCKER_USER=$USER \
    -e DOCKER_USER_ID=$(id -u) \
    -e DOCKER_GRP=$(id -g -n) \
    -e DOCKER_GRP_ID=$(id -g) \
    -v /private:/private \
    -v /data:/data \
    -p 6016:6016 \
    -p 8892:8892 \
    --ipc host \
    -v /home/$USER:/$USER \
    -w /$USER \
    --name $DOCKER_NAME $IMG:$VERSION \
    $SHELL
   
# docker exec $DOCKER_NAME service ssh start
eval docker exec $DOCKER_NAME bash "/root/add_user.sh"

## copy common configuration files
docker cp -L ~/.vim $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.spf13-vim-3/ $DOCKER_NAME:/home/$DOCKER_USER
# docker cp -L ~/.vimrc $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.gitconfig $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.ssh $DOCKER_NAME:/home/$DOCKER_USER


## install oh my zsh
docker cp $(dirname $0)/install-ohmyzsh.sh $DOCKER_NAME:/home/$DOCKER_USER
eval docker exec -u $DOCKER_USER $DOCKER_NAME bash "~/install-ohmyzsh.sh"

## set pip source
eval docker exec -u $DOCKER_USER $DOCKER_NAME pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

## install spf13-theme for vim in docker
# docker exec $DOCKER_NAME -u $DOCKER_USER sh -c "/root/spf13-vim.sh"

