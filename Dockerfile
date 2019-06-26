FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer="cheerss"

COPY sources-16.04.list /etc/apt/sources.list

RUN rm /etc/apt/sources.list.d/cuda.list && rm /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y \
        cmake curl vim-nox zsh ssh htop software-properties-common libconfig-dev locales\
        unzip zip git gdb bison flex sudo locales man automake libboost-all-dev

## get python3.6.8 and pip
RUN add-apt-repository ppa:deadsnakes/ppa && \
    sed -i "s/http:\/\/ppa\.launchpad\.net/https:\/\/launchpad.proxy.ustclug.org/g" /etc/apt/sources.list.d/*.list && \
    apt update && apt install -y python3.6 python3.6-dev python3-distutils-extra && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && python3.6 /tmp/get-pip.py && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python3 && \
    ln -s /usr/bin/python3.6 /usr/local/bin/python
    
## install git-lfs
WORKDIR /tmp
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt update && apt install -y git-lfs && git lfs install && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 6B05F25D762E3157 && apt update
    
## python common libraries
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple setuptools && pip install -i https://pypi.tuna.tsinghua.edu.cn/simple wheel numpy scipy matplotlib \
  ipython jupyter opencv-python==3.3.1.11 Pillow scikit-image six==1.11.0 && \

# dependencies of opencv
    apt update && apt install -y libsm6 libxext6 libxrender1 && \

# python tensorflow
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow-gpu==1.12.0 tensorboard==1.12.0 && \

# pytorch-1.1.0
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple torch tensorboardX && \

# python mxnet
    pip install -i https://pypi.tuna.tsinghua.edu.cn/simple mxnet-cu90
    
## install caffe-SSD
RUN apt-get install libhdf5-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libboost-all-dev protobuf-compiler libprotobuf-dev libblas-dev libatlas-base-dev libopenblas-dev libleveldb-dev libsnappy-dev


RUN locale-gen en_US.utf8
ENV LC_ALL=en_US.utf8
COPY add_user.sh /root/add_user.sh

