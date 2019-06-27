
VERSION="tmp-caffe"
DOCKER_NAME="${USER}_deep_docker"
DOCKER_USER="${USER}"
IMG="cheerss/deep-docker"
SHELL=/usr/bin/zsh

eval nvidia-docker run -it -d \
    -e DOCKER_USER=$USER \
    -e DOCKER_USER_ID=$(id -u) \
    -e DOCKER_GRP=$(id -g -n) \
    -e DOCKER_GRP_ID=$(id -g) \
    -v /private:/private \
    -p 6006:6006 \
    -p 8890:8890 \
    -v /home/$USER:/$USER \
    -v /nfs:/nfs \
    -w /$USER \
    --name $DOCKER_NAME $IMG:$VERSION \
    $SHELL
   
# docker exec $DOCKER_NAME service ssh start
eval docker exec $DOCKER_NAME bash "/root/add_user.sh"

## install oh my zsh
docker cp $(dirname $0)/install-ohmyzsh.sh $DOCKER_NAME:/home/$DOCKER_USER
eval docker exec -u $DOCKER_USER $DOCKER_NAME bash "~/install-ohmyzsh.sh"

## set pip source
eval docker exec -u $DOCKER_USER $DOCKER_NAME pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

## copy common configuration files
docker cp -L ~/.vim $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.spf13-vim-3/ $DOCKER_NAME:/home/$DOCKER_USER
# docker cp -L ~/.vimrc $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.gitconfig $DOCKER_NAME:/home/$DOCKER_USER
docker cp -L ~/.ssh $DOCKER_NAME:/home/$DOCKER_USER

## install spf13-theme for vim in docker
# docker exec $DOCKER_NAME -u $DOCKER_USER sh -c "/root/spf13-vim.sh"

