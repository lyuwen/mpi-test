# vim: filetype=dockerfile

FROM fulvwen/intel-mpi-runtime:2021.3.0-devel AS builder

RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpiicc -o app.x src/mpi_test.c


# FROM ghcr.io/lyuwen/intel-mpi-runtime:2021.3.0
FROM fulvwen/intel-mpi-runtime:2021.3.0

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      libucx-dev ucx-utils \
      && \
    apt-get autoremove --purge -y && \
    apt-get autoclean -y && \
    rm -rf /var/cache/apt/* /var/lib/apt/lists/*

COPY --from=builder /opt/apps /opt/apps
WORKDIR /opt/apps

ENV PATH=/opt/apps:$PATH

CMD ["/opt/apps/app.x"]
