ARG TAG=dev
FROM abcdesktopio/oc.template.gtk:$TAG
MAINTAINER Alexandre DEVELY 
ENV DEBIAN_FRONTEND noninteractive

RUN add-apt-repository ppa:linuxuprising/java
RUN echo oracle-java16-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections
#
# oracle-java16-installer with --install-recommends also installs oracle-java16-set-default
RUN apt-get update && apt-get install -y --install-recommends \
        oracle-java16-installer         \
        gsfonts-x11                     \
        java-common                     \
