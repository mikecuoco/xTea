FROM mambaorg/micromamba:0.27.0
MAINTAINER Mike Cuoco (mcuoco@ucsd.edu)

COPY --chown=$MAMBA_USER:$MAMBA_USER env.yaml /tmp/env.yaml
RUN micromamba install --yes --file /tmp/env.yaml && \
    micromamba clean --all --yes
ARG MAMBA_DOCKERFILE_ACTIVATE=1 

## xTea
USER root
WORKDIR /usr/local/bin
RUN git clone https://github.com/mikecuoco/xTea.git && \
    cd xTea && \
    git checkout MC_cloud && \
    cd .. && \
    cp -r xTea/xtea/* .
RUN rm -rf xTea
RUN chmod +x *.py
