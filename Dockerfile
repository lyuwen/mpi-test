FROM ubuntu:latest

RUN sed -i -e 's/archive.ubuntu.com/mirrors.ustc.edu.cn/' -e 's/security.ubuntu.com/mirrors.ustc.edu.cn/' /etc/apt/sources.list

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      gcc g++ \
      libgmp-dev \
      libmpich-dev \
      libucx-dev ucx-utils \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*


RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpicc -o app.x src/mpi_test.c

ENV PATH=/opt/apps:$PATH

CMD ["/opt/apps/app.x"]
