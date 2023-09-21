# vim: filetype=dockerfile

# FROM intel/oneapi-hpckit:2021.4-devel-ubuntu18.04 AS builder
FROM fulvwen/intel-mpi-runtime:2021.3.0-devel AS builder

RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpiicc -o app.x src/mpi_test.c


# FROM ghcr.io/lyuwen/intel-mpi-runtime:2021.3.0
FROM fulvwen/intel-mpi-runtime:2021.3.0

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      wget \
      && \
    wget -O /tmp/ucx.deb https://github.com/openucx/ucx/releases/download/v1.12.1/ucx-v1.12.1-ubuntu18.04-mofed5-cuda11.deb && \
    apt install -y /tmp/ucx.deb && apt install -yf && rm -f /tmp/ucx.deb && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

COPY --from=builder /opt/apps /opt/apps
WORKDIR /opt/apps

ENV PATH=/opt/apps:$PATH

CMD ["/opt/apps/app.x"]
