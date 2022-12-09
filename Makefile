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

ifndef NOCACHE
 NOCACHE=
endif

# count core to run several make in parallel 
CORE_COUNT=$(shell getconf _NPROCESSORS_ONLN) 

all: pull minimal level0 gtk level1 level2

pull:
	# pull default docker images
	@echo "-----------------"
	@echo "--- make pull ---"
	@echo "-----------------"
	docker pull debian:stable-slim
	docker pull ubuntu:18.04
	docker pull ubuntu:20.04
	docker pull ubuntu:22.04
	docker pull alpine:latest

minimal: 
	@echo "--------------------"
	@echo "--- make minimal ---"
	@echo "--------------------"
	@echo "minimal use TAG=$(TAG)"\;
	@echo "minimal use PROXY=$(PROXY)"\;
	@echo "minimal use NOCACHE=$(NOCACHE)"\;
	# build minimal
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=alpine       	   -t abcdesktopio/oc.template.alpine.minimal:$(TAG)  		-f oc.template.alpine.minimal .
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=ubuntu:18.04 	   -t abcdesktopio/oc.template.ubuntu.minimal.18.04:$(TAG)  	-f oc.template.ubuntu.minimal .
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=ubuntu:20.04 	   -t abcdesktopio/oc.template.ubuntu.minimal.20.04:$(TAG)    	-f oc.template.ubuntu.minimal .
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=ubuntu:22.04       -t abcdesktopio/oc.template.ubuntu.minimal.22.04:$(TAG)    	-f oc.template.ubuntu.minimal .
	# note ubuntu is a debian 
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=debian:stable-slim -t abcdesktopio/oc.template.debian.minimal:$(TAG)    	-f oc.template.ubuntu.minimal .

level0:
	# build oc.template
	@echo "----------------------------"
	@echo "--- make level0 template ---"
	@echo "----------------------------"
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine.minimal        -t abcdesktopio/oc.template.alpine:$(TAG)                 -f oc.template.alpine .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.18.04  -t abcdesktopio/oc.template.ubuntu.18.04:$(TAG)  		-f oc.template.ubuntu .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.20.04  -t abcdesktopio/oc.template.ubuntu.20.04:$(TAG)  		-f oc.template.ubuntu .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.22.04  -t abcdesktopio/oc.template.ubuntu.22.04:$(TAG)  		-f oc.template.ubuntu .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian.minimal        -t abcdesktopio/oc.template.debian:$(TAG) -f oc.template.ubuntu .

gtk:
	# build gtk
	#
	@echo "----------------"
	@echo "--- make gtk ---"
	@echo "----------------"
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.20.04  -t abcdesktopio/oc.template.ubuntu.gtk:$(TAG) -f oc.template.ubuntu.gtk .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian 	      -t abcdesktopio/oc.template.debian.gtk:$(TAG) -f oc.template.ubuntu.gtk .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine        -t abcdesktopio/oc.template.alpine.gtk:$(TAG) -f oc.template.alpine.gtk .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.18.04  -t abcdesktopio/oc.template.ubuntu.gtk.18.04:$(TAG)  	-f oc.template.ubuntu.gtk .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.20.04  -t abcdesktopio/oc.template.ubuntu.gtk.20.04:$(TAG)    	-f oc.template.ubuntu.gtk .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk    -t abcdesktopio/oc.template.ubuntu.gtk.language-pack-all:$(TAG) -f oc.template.ubuntu.gtk.language-pack-all .

# remove the first .
level1:
	echo "level1 use TAG=$(TAG)"\;
	docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine 	-t abcdesktopio/oc.template.alpine.libreoffice:$(TAG) -f oc.template.alpine.libreoffice .
	docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk 	-t abcdesktopio/oc.template.ubuntu.gtk.java:$(TAG) -f oc.template.ubuntu.gtk.java .
	docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk 	-t abcdesktopio/oc.template.ubuntu.gtk.libreoffice:$(TAG) 		-f oc.template.gtk.libreoffice .
	docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.22.04   -t abcdesktopio/oc.template.ubuntu.wine:$(TAG) -f oc.template.ubuntu.wine .

level2:
	echo "level2 use TAG=$(TAG)"\;
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.wine.22.04  -t abcdesktopio/oc.template.ubuntu.wine.mswindows:$(TAG) -f oc.template.ubuntu.wine.mswindows .
	docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine.minimal -t abcdesktopio/oc.template.alpine.wine:$(TAG) -f oc.template.alpine.wine .

ai:
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.fulldev.ia:$(TAG) -f oc.template.gtk.fulldev.ia

clean:
	docker rmi `docker images -q --filter "dangling=true"` || true
	docker rm `docker ps -a -q -f "status=exited"` || true
