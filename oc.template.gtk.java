FROM abcdesktopio/oc.template.gtk
MAINTAINER Alexandre DEVELY 


RUN DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:linuxuprising/java
RUN DEBIAN_FRONTEND=noninteractive echo oracle-java15-installer shared/accepted-oracle-license-v1-2 select true | /usr/bin/debconf-set-selections
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends \
        oracle-java15-installer         \
        gsfonts-x11                     \
        java-common                     \
        oracle-java15-set-default
