FROM centos:7

RUN yum -y update
RUN yum clean all
RUN yum -y install centos-release-scl
RUN yum -y install devtoolset-8-gcc-c++ devtoolset-8-gcc-gfortran
RUN yum -y install autoconf automake curl git libtool make python27 which
RUN yum clean all

RUN echo PATH=/opt/rh/devtoolset-8/root/usr/bin/:\$PATH >> /etc/bashrc

RUN cd /tmp && \
    curl -fsSRLO https://github.com/Kitware/CMake/releases/download/v3.17.0/cmake-3.17.0-Linux-x86_64.tar.gz && \
    mkdir -p /usr/local/cmake && \
    tar zxvf cmake-3.17.0-Linux-x86_64.tar.gz -C /usr/local/cmake --strip-components=1 && \
    rm -f cmake-3.17.0-Linux-x86_64.tar.gz && \
    echo export PATH=/usr/local/cmake/bin:\$PATH >> /etc/bashrc

RUN mkdir -p /tmp/ufs-weather-model-ci-docker
COPY . /tmp/ufs-weather-model-ci-docker

RUN . /etc/bashrc && \
    cd /tmp/ufs-weather-model-ci-docker/libs/mpilibs && \
    ./build.sh gnu && \
    echo export PATH=/usr/local/mpich3/bin:\$PATH >> /etc/bashrc

RUN . /etc/bashrc && \
    cd /tmp/ufs-weather-model-ci-docker && \
    ./get.sh && ./build.sh gnu -3rdparty -nceplibs && \
    cd && rm -rf /tmp/ufs-weather-model

CMD ["/bin/bash"]
