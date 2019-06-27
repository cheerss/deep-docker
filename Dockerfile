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
WORKDIR /tmp
COPY boost_1_58_0.tar.bz2 /tmp/boost_1_58_0.tar.bz2
COPY opencv-3.3.1.zip /tmp/opencv-3.3.1.zip
COPY caffe-weiliu-1 /usr/local/caffe-ssd

RUN apt-get update && apt-get -y install libhdf5-dev libgflags-dev libgoogle-glog-dev liblmdb-dev libboost-all-dev protobuf-compiler libprotobuf-dev libblas-dev libatlas-base-dev libopenblas-dev libleveldb-dev libsnappy-dev && \
# install opencv-3.3.1
# RUN wget -c -t0 https://github.com/opencv/opencv/archive/3.3.1.zip -O /tmp/opencv-3.3.1.zip && \
    unzip opencv-3.3.1.zip && \
    mkdir /tmp/opencv-3.3.1/build && \
    cd /tmp/opencv-3.3.1/build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D BUILD_opencv_python2=OFF \
      -D BUILD_opencv_python3=OFF \
      -D PYTHON3_EXECUTABLE=$(which python3) \
      -D PYTHON3_INCLUDE_DIR=/usr/include/python3.6m \
      -D PYTHON3_LIBRARY=/usr/lib/x86_64-linux-gnu/libpython3.6m.so.1 \
      -D CMAKE_INSTALL_PREFIX=/usr/local/opencv-3.3.1 \
      -D WITH_CUDA=ON \
      -D ENABLE_FAST_MATH=1 \
      -D CUDA_FAST_MATH=1 \
      -D WITH_CUBLAS=1 \
      -D CUDA_ARCH_BIN="35 50 60 61 70" \
      -D WITH_IPP=0 \
      .. && \
    make -j && \
    make install -j && \
    echo /usr/local/opencv-3.3.1/lib > /etc/ld.so.conf.d/opencv-3.3.1.conf && \
# install boost-1.58.0
    cd /tmp && tar -jxvf boost_1_58_0.tar.bz2 && cd boost_1_58_0 && \
      ./bootstrap.sh --with-libraries=python --with-toolset=gcc && \
      ./b2 --with-python include="/usr/include/python3.6m/" && \
      ./b2 install && \   
# install caffe !!! Makefile.config
    cd /usr/local/caffe-ssd && git checkout ssd && make all -j && make pycaffe -j && rm -rf /tmp/*

RUN locale-gen en_US.utf8
ENV LC_ALL=en_US.utf8 \
    PKG_CONFIG_PATH=/usr/local/opencv-3.3.1/lib/pkgconfig \
    LD_LIBRARY_PATH=/usr/local/lib:/usr/local/opencv-3.3.1/lib:$LD_LIBRARY_PATH \
    PYTHONPATH=/usr/local/caffe-ssd/python:$PYTHONPATH \
    PATH=/usr/local/caffe-ssd/build/tools:$PATH
COPY add_user.sh /root/add_user.sh

