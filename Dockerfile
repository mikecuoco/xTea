#######################################################################
#     Basic image
#######################################################################
FROM ubuntu:16.04
MAINTAINER Mike Cuoco (mcuoco@ucsd.edu)

# Install dependencies
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    gcc \
    git \
    less \
    libncurses-dev \
    make \
    time \
    unzip \
    vim \
    wget \
    zlib1g-dev \
    liblz4-tool

WORKDIR /usr/local/bin

## conda and pysam
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.10.3-Linux-x86_64.sh && bash Miniconda3-py38_4.10.3-Linux-x86_64.sh -p /miniconda -b
ENV PATH=/miniconda/bin:$PATH
RUN conda config --add channels r \
    && conda config --add channels bioconda \
    && conda install -c conda-forge libgcc-ng \
    && conda install -c bioconda samtools==1.6 \
    && conda install -c bioconda bwa==0.7.17 \
    && conda install pysam==0.17.0 sortedcontainers==2.4.0 numpy==1.22.3 pandas==1.4.2 scikit-learn==1.0.2 -y

## deep-forest
RUN pip install deep-forest==0.1.5

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

## Supporting UTF-8
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

CMD ["ls /usr/local/bin"]
