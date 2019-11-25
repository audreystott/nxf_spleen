FROM ubuntu:bionic
MAINTAINER Audrey Stott "audrey.stott@pawsey.org.au"

RUN apt-get update \
    && apt-get -y install software-properties-common \
    && apt-get update \
    && add-apt-repository ppa:longsleep/golang-backports \
    && apt-get update \
    && apt-get -y install \
    golang-1.11-go

RUN apt-get -y install curl \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] \
    && . "$NVM_DIR/nvm.sh" \
    && [ -s "$NVM_DIR/bash_completion" ] \
    && . "$NVM_DIR/bash_completion" \
    && nvm install node \
    && nvm install 8.11.4 \
    && nvm use 8.11.4 \
    && nvm alias default 8.11.4

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH /root/.cargo/bin:$PATH

RUN apt-get update \
    && apt-get -y install \
    clang-6.0 \
    python-minimal #installs python 2.7 on ubuntu 18.04 \
    && apt-get -y install git \
    && sudo git clone https://github.com/10XGenomics/cellranger.git \
    && cd cellranger \
    && make \

ENV PATH /cellranger/bin/:$PATH

RUN apt-get update \
    && apt-get install -y alien unzip wget \
    && wget https://support.illumina.com/content/dam/illumina-support/documents/downloads/software/bcl2fastq/bcl2fastq2-v2-19-1-linux.zip \
    && unzip bcl2fastq2*.zip \
    && alien bcl2fastq2*.rpm \
    && dpkg -i bcl2fastq2*.deb \
    && rm bcl2fastq2*.deb bcl2fastq2*.rpm bcl2fastq2*.zip