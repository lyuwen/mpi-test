# vim: filetype=dockerfile

FROM intel/oneapi-hpckit:2023.2.1-devel-ubuntu22.04 AS builder

RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpiicc -o app.x src/mpi_test.c


FROM ghcr.io/lyuwen/intel-mpi-runtime:main

COPY --from=builder /opt/apps /opt/apps
WORKDIR /opt/apps

ENV PATH=/opt/apps:$PATH

CMD ["/opt/apps/app.x"]
