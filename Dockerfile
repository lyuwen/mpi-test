# vim: filetype=dockerfile

FROM intel/oneapi-hpckit:2021.4-devel-ubuntu18.04 AS builder

RUN mkdir -p /opt/apps
COPY src /opt/apps/src
WORKDIR /opt/apps

RUN mpiicc -o app.x src/mpi_test.c


FROM ghcr.io/lyuwen/intel-mpi-runtime:2021.3.0

COPY --from=builder /opt/apps /opt/apps
WORKDIR /opt/apps

ENV PATH=/opt/apps:$PATH

CMD ["/opt/apps/app.x"]
