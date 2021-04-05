ARG TAG=dev
FROM abcdesktopio/oc.template.gtk:$TAG
MAINTAINER Alexandre DEVELY 
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:linuxuprising/java
RUN echo oracle-java15-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections
RUN apt-get update && apt-get install -y --no-install-recommends \
        oracle-java16-installer         \
        gsfonts-x11                     \
        java-common                     \
        oracle-java16-set-default
