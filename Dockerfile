FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL maintainer="cheerss"

COPY sources-18.04.list /etc/apt/sources.list
# COPY pytorch /tmp/pytorch
# COPY tensorflow_gpu-2.2.0-cp36-cp36m-manylinux2010_x86_64.whl /tmp/tensorflow_gpu-2.2.0-cp36-cp36m-manylinux2010_x86_64.whl
# COPY nvidia_dali-0.21.0-1239036-cp36-cp36m-manylinux1_x86_64.whl /tmp/nvidia_dali-0.21.0-1239036-cp36-cp36m-manylinux1_x86_64.whl

RUN rm /etc/apt/sources.list.d/cuda.list && rm /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y \
        cmake curl vim-nox zsh ssh htop software-properties-common libconfig-dev locales\
        unzip zip git gdb bison flex sudo locales man automake libboost-all-dev net-tools iproute2

## get python3-pip and install python3.6.9 automatically
WORKDIR /tmp
RUN apt install -y python3-pip && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/pip3 /usr/local/bin/pip && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python && \
    pip install --upgrade pip -i  https://mirrors.aliyun.com/pypi/simple/ && \
    pip install -i https://mirrors.aliyun.com/pypi/simple/ wheel numpy scipy matplotlib \
        ipython jupyter opencv-python==3.3.1.11 Pillow scikit-image six==1.11.0 pandas && \

# dependencies of opencv
    apt update && apt install -y libsm6 libxext6 libxrender1 && \

# python tensorflow-2.2.0
    # pip install -i https://mirrors.aliyun.com/pypi/simple/ tensorflow_gpu-2.2.0-cp36-cp36m-manylinux2010_x86_64.whl && \
    # pip install -i https://mirrors.aliyun.com/pypi/simple/ tensorboard && \
    pip install -i https://mirrors.aliyun.com/pypi/simple/ tensorflow-gpu tensorboard && \

# pytorch-1.5.0
    pip install -i https://mirrors.aliyun.com/pypi/simple/ numpy ninja pyyaml mkl mkl-include setuptools cmake cffi && \
    git config --global https.proxy socks5://xx.xx.xx.xx:xxxx && \
    git config --global http.proxy socks5://xx.xx.xx.xx:xxxx && \
    git clone --recursive https://github.com/pytorch/pytorch && \
    cd pytorch && git checkout v1.5.0 && git submodule sync && git submodule update --init --recursive && \
    PYTORCH_BUILD_VERSION=1.5.0 PYTORCH_BUILD_NUMBER=0 python setup.py install && cd .. \

# torchvision, tensorboardX, apex, dali
    pip install -i https://mirrors.aliyun.com/pypi/simple/ torchvision tensorboardX && \
    git clone https://github.com/NVIDIA/apex && cd apex && \
    pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" ./ && \
    pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/cuda/10.0 nvidia-dali && \
    # pip install -i https://mirrors.aliyun.com/pypi/simple/ /tmp/nvidia_dali-0.21.0-1239036-cp36-cp36m-manylinux1_x86_64.whl && \
    cd .. && \

## clear enviroment
    rm -r /tmp/*

RUN locale-gen en_US.utf8
ENV LC_ALL=en_US.utf8
COPY add_user.sh /root/add_user.sh

