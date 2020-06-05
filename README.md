# deep-docker

The docker image has been released to [DockerHub](https://hub.docker.com/r/cheerss/deep-docker)

## Requirement

NVIDIA DRIVER VERSION >= 418.48 (compatible with CUDA10.0 according to [here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html))

nvidia-docker

## Quick Start

ensure `echo $USER` output your username first. If not, set it with `export USER="your_user_name"`

```
bash start_docker.sh # start a container named $USER_deep_docker
bash enter_docker.sh # enter the docker
```

## Base

nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

## Deep Learning Libraries

| Library     | version     | Note                          |
| ----------- | ----------- | ----------------------------- |
| Tensorflow  | 2.2.0      | GPU-version, with Tensorboard  |
| pytorch     | 1.5.0 | with TensorboardX, torchvision      |
| apex        | 0.1 |         |
| nvidia-dali     | 0.21.0 |      |

## Other Python Libraries

numpy scipy scikit-image Pillow opencv-3.3.1 matplotlib ipython jupyter pandas

## Other Libraries

cmake automake oh-my-zsh(install during starting a container)
