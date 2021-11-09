ARG TAG=dev
FROM abcdesktopio/oc.template.gtk:$TAG
MAINTAINER Alexandre DEVELY 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y --install-recommends \
        default-jre         \
        gsfonts-x11                     
