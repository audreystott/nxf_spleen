FROM continuumio/miniconda:4.7.12 AS first-build
MAINTAINER Audrey Stott "audrey.stott@pawsey.org.au"
RUN apt-get -y install ttf-dejavu
COPY conda.yml .
RUN \
   conda env update -n root -f conda.yml \
   && conda clean -a
RUN apt-get update && apt-get install -y procps

FROM ubuntu:bionic AS second-build
MAINTAINER Audrey Stott "audrey.stott@pawsey.org.au"
COPY --from=first-build /opt /opt
ADD cellranger_url.txt /home/
ARG CELLRANGER_VERSION="3.1.0"
ARG CELLRANGER_WEB_TOKEN="/home/cellranger_url.txt"
RUN mkdir -p /tmp/cellranger-build \
    && cd /tmp/cellranger-build \
    && apt-get update \
    && apt-get install -y wget \
    && wget -O cellranger-${CELLRANGER_VERSION}.tar.gz -i ${CELLRANGER_WEB_TOKEN} \
    && mkdir /apps \
    && mv cellranger-${CELLRANGER_VERSION}.tar.gz /apps/ \
    && cd /apps \
    && tar -xzvf cellranger-${CELLRANGER_VERSION}.tar.gz \
    && rm -f cellranger-${CELLRANGER_VERSION}.tar.gz \
    && rm -rf /tmp/cellranger-build
ENV PATH /apps/cellranger-${CELLRANGER_VERSION}:$PATH
ENV PATH /opt/conda/bin:$PATH