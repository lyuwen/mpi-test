# vim: filetype=dockerfile

FROM intel/oneapi-hpckit:2023.2.1-devel-ubuntu22.04 AS builder

RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpiicc -o app.x src/mpi_test.c


FROM ghcr.io/lyuwen/intel-mpi-runtime:main

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
