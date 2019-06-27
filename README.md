# deep-docker

The docker image has been released to [DockerHub](https://hub.docker.com/r/cheerss/deep-docker)

## Requirement

NVIDIA DRIVER VERSION >= 384.81 (compatible with CUDA9.0 according to [here](https://docs.nvidia.com/cuda/cuda-toolkit-release-notes/index.html))

nvidia-docker

## Quick Start

ensure `echo $USER` output your username first. If not, set it with `export USER="your_user_name"`

```
bash start_docker.sh # start a container named $USER_deep_docker
bash enter_docker.sh # enter the docker
```

## Base

nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

## Deep Learning Libraries

| Library     | version     | Note                          |
| ----------- | ----------- | ----------------------------- |
| Tensorflow  | 1.12.0      | GPU-version, with Tensorboard |
| MXNet-cu90 | 1.4.1       |                               |
| pytorch     | 1.1.0 | with TensorboardX             |
| caffe-ssd     | 1.0.0 | GPU version             |

## Other Python Libraries

numpy scipy scikit-image Pillow opencv-3.3.1 matplotlib ipython jupyter

## Other Libraries

git-lfs cmake automake oh-my-zsh(install during starting a container)
