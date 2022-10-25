ARG TAG=dev
ARG BASE_IMAGE=abcdesktopio/oc.template.gtk
FROM ${BASE_IMAGE}:$TAG
MAINTAINER Alexandre DEVELY 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --install-recommends \
        default-jre	\
        gsfonts-x11   	\
    && rm -rf /var/lib/apt/lists/*	
