# Software Name : abcdesktop.io
# Version: 0.2
# SPDX-FileCopyrightText: Copyright (c) 2020-2021 Orange
# SPDX-License-Identifier: GPL-2.0-only
#
# This software is distributed under the GNU General Public License v2.0 only
# see the "license.txt" file for more details.
#
# Author: abcdesktop.io team
# Software description: cloud native desktop service
#

##
# define a tag to build docker registry image
# the default tag is dev
# usage
# TAG=dev make
# TAG=latest make
#
ifndef TAG
 TAG=dev
endif 

ifndef PROXY
 PROXY=
endif

# count core to run several make in parallel 
CORE_COUNT=$(shell getconf _NPROCESSORS_ONLN) 

all:
	@echo Note: You can use the command make -j $(CORE_COUNT) to use all cores
	# pull default docker images
	docker pull debian:stable-slim
	docker pull ubuntu:18.04
	docker pull ubuntu:20.04
	docker pull ubuntu:22.04
	# $(MAKE) removeexitedcontainer
	# $(MAKE) cleandangling
	echo "Makefile use TAG=$(TAG)"\;
	$(MAKE) level0
	$(MAKE) level1
	$(MAKE) level2

level0: 
	echo "level0 use TAG=$(TAG)"\;
	echo "level0 use PROXY=$(PROXY)"\;
	docker build $(PROXY) --build-arg BASE_IMAGE=ubuntu:22.04                       -t abcdesktopio/oc.template:$(TAG)              -f oc.template .
	docker build $(PROXY) --build-arg BASE_IMAGE=ubuntu:20.04        		-t abcdesktopio/oc.template.20.04:$(TAG)   	-f oc.template .
	docker build $(PROXY) --build-arg BASE_IMAGE=ubuntu:18.04                       -t abcdesktopio/oc.template.18.04:$(TAG)        -f oc.template .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=debian:stable-slim  		-t abcdesktopio/oc.template.debian:$(TAG)   	-f oc.template .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template  		-t abcdesktopio/oc.template.gtk:$(TAG)    	-f oc.template.gtk .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian  	-t abcdesktopio/oc.template.debian.gtk:$(TAG)   -f oc.template.gtk .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.18.04   	-t abcdesktopio/oc.template.gtk.18.04:$(TAG) 	-f oc.template.gtk .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.20.04     -t abcdesktopio/oc.template.gtk.20.04:$(TAG)    -f oc.template.gtk .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk     	-t abcdesktopio/oc.template.gtk.elementary:$(TAG) 	 -f oc.template.gtk.elementary . 
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk     	-t abcdesktopio/oc.template.gtk.language-pack-all:$(TAG) -f oc.template.gtk.language-pack-all .

# remove the first .
level1:
	echo "level1 use TAG=$(TAG)"\;
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk 	  -t abcdesktopio/oc.template.gtk.java:$(TAG)    			-f oc.template.gtk.java .
	# docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk 	  -t abcdesktopio/oc.template.gtk.fulldev:$(TAG)	 		-f oc.template.gtk.fulldev .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk 	  -t abcdesktopio/oc.template.gtk.libreoffice:$(TAG) 		-f oc.template.gtk.libreoffice .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian.gtk  -t abcdesktopio/oc.template.debian.gtk.firefox:$(TAG) 		-f oc.template.gtk.firefox .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template 		  -t abcdesktopio/oc.template.wine:$(TAG) 			-f oc.template.wine .
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.gtk         -t abcdesktopio/oc.template.gtk.gimagereader 			-f oc.template.gtk.gimagereader .

level2:
	echo "level2 use TAG=$(TAG)"\;
	docker build $(PROXY) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian.gtk.firefox -t abcdesktopio/oc.template.debian.gtk.firefox.rest:$(TAG) -f oc.template.gtk.firefox.rest .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.wine.mswindows:$(TAG) -f oc.template.wine.mswindows .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.java.sts4:$(TAG) -f oc.template.gtk.java.sts4 .

ai:
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.fulldev.ia:$(TAG) -f oc.template.gtk.fulldev.ia

push:
	for dir in $(dockertemplate); do \
		docker push abcdesktopio/$$dir:$(TAG) ;\
        done 

cleandangling:
	docker rmi `docker images -q --filter "dangling=true"` || true


removeexitedcontainer:
	docker rm `docker ps -a -q -f "status=exited"` || true

clean:
	for dir in $(dockertemplate); do \
		docker rmi abcdesktopio/$$dir:$(TAG) ;\
		docker rmi $$dir ;\
        done 
