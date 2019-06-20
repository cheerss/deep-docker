# deep-docker

PLEASE USE OTHER BRANCHES, MASTER BRANCH IS ONLY FOR DEVELOPMENT

## Requirement

NVIDIA DRIVER VERSION: >=410.104

## Quick Start

ensure `echo $USER` output your username first. If not, set it with `export USER="your user name"`

```
bash start_docker.sh # start a container named $USER_deep_docker
bash enter_docker.sh # enter the docker
```

## Base

nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

## Deep Learning Libraries

| Library     | version     | Note                          |
| ----------- | ----------- | ----------------------------- |
| Tensorflow  | 1.13.0      | GPU-version, with Tensorboard |
| MXNet-cu100 | 1.4.1       |                               |
| pytorch     | 1.0.1.post2 | with TensorboardX             |

## Other Python Libraries

numpy scipy scikit-image Pillow opencv-3.3.1 matplotlib ipython jupyter

## Other Libraries

git-lfs cmake automake oh-my-zsh(install during starting a container)
