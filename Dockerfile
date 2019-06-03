FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04
LABEL maintainer="cheerss"

COPY sources.list /etc/apt/sources.list

RUN rm /etc/apt/sources.list.d/cuda.list && rm /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y tzdata \
    && echo "Asia/Shanghai" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get install -y \
        cmake curl vim-nox zsh ssh htop software-properties-common libconfig-dev locales\
        unzip zip git gdb bison flex python3-pip sudo locales man automake libboost-all-dev 
        
# install git-lfs
WORKDIR /tmp
RUN curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | bash && apt-get install -y git-lfs && git lfs install && apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 6B05F25D762E3157 && apt update

# pytorch-1.0
COPY torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl /tmp/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl
RUN pip3 install /tmp/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl && rm -rf /tmp/* && pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorboardX

# python tensorflow
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple tensorflow-gpu tensorboard

# python mxnet
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple mxnet-cu100

# python common libraries
RUN pip3 install -i https://pypi.tuna.tsinghua.edu.cn/simple numpy scipy matplotlib \
    ipython jupyter opencv-python==3.3.1.11 Pillow scikit-image
# needed by opencv-python
RUN apt install -y libsm6 libxext6 libxrender1

# # eigen3
# WORKDIR /tmp/
# RUN wget -c http://bitbucket.org/eigen/eigen/get/3.3.7.tar.gz && \
#     tar -zxvf 3.3.7.tar.gz && cd eigen-eigen-323c052e1731 && mkdir build && cd build && \
#     cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&  make && make install && \
#     cd / && rm -rf /tmp/*

# # install deps for opencv
# RUN apt-get update && apt-get install -y \
#       libtbb2 \
#       libtbb-dev \
#       libjpeg-dev \
#       libpng-dev \
#       libtiff-dev \
#       libjasper-dev \
#       libdc1394-22-dev \
#       libgtk2.0-dev && \
#       apt-get clean autoclean && rm -rf /var/lib/apt/lists/* 

# WORKDIR /tmp
# RUN wget -c -t0 https://github.com/opencv/opencv/archive/3.3.1.zip -O /tmp/opencv-3.3.1.zip && \
#     unzip opencv-3.3.1.zip && \
#     mkdir /tmp/opencv-3.3.1/build && \
#     cd /tmp/opencv-3.3.1/build && \
#     cmake -D CMAKE_BUILD_TYPE=RELEASE \
#       -D CMAKE_INSTALL_PREFIX=/usr/local/opencv-3.3.1 \
#       -D WITH_CUDA=ON \
#       -D ENABLE_FAST_MATH=1 \
#       -D CUDA_FAST_MATH=1 \
#       -D WITH_CUBLAS=1 \
#       -D CUDA_ARCH_BIN="35 50 60 61 70" \
#       -D WITH_IPP=0 \
#       .. && \
#     make -j && \
#     make install -j && \
#     cd / && rm -rf /tmp/*
# RUN echo /usr/local/opencv-3.3.1/lib > /etc/ld.so.conf.d/opencv-3.3.1.conf && ldconfig && export PKG_CONFIG_PATH=/usr/local/opencv-3.3.1/lib/pkgconfig

## set python3 to default
RUN ln -s /usr/bin/pip3 /usr/bin/pip; rm /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python


RUN locale-gen en_US.utf8
ENV LC_ALL=en_US.utf8
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/cuda/compat
COPY add_user.sh /root/add_user.sh

