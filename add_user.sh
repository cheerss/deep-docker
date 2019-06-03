
addgroup --gid "$DOCKER_GRP_ID" "$DOCKER_GRP"
adduser --disabled-password --gecos '' "$DOCKER_USER" \
    --uid "$DOCKER_USER_ID" --gid "$DOCKER_GRP_ID" 2>/dev/null
echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
usermod -aG sudo $DOCKER_USER
