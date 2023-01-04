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


define generate_file
    # docker rmi abcdesktopio/$(2):$(TAG)
	docker build $(PROXY) $(NOCACHE) --build-arg BASE_IMAGE=$(1) -t abcdesktopio/$(2):$(TAG) -f $(3) .
	node make-docs.js $(1) $(2):$(TAG) $(3)
endef


all: pull minimal level0 gtk level1 level2

cuda: 
	# pull default nvidia/cuda images
	@echo "-----------------"
	@echo "--- make pull ---"
	@echo "-----------------"
	for i in nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia/cuda:12.0.0-base-ubuntu20.04 ; do \
		echo pulling $$i ;  \
		docker pull $$i ; \
    done
	$(call generate_file,nvidia/cuda:12.0.0-base-ubuntu20.04,oc.template.ubuntu.nvidia.20.04,oc.template.ubuntu.minimal)
	$(call generate_file,nvidia/cuda:12.0.0-base-ubuntu22.04,oc.template.ubuntu.nvidia.22.04,oc.template.ubuntu.minimal)

pull:
	# pull default docker images
	@echo "-----------------"
	@echo "--- make pull ---"
	@echo "-----------------"
	for i in debian:stable-slim ubuntu:18.04 ubuntu:20.04 ubuntu:22.04 alpine:latest ; do \
		echo pulling $$i ;  \
		docker pull $$i ; \
    done


minimal: 
	@echo "--------------------"
	@echo "--- make minimal ---"
	@echo "--------------------"
	@echo "minimal use TAG=$(TAG)"\;
	@echo "minimal use PROXY=$(PROXY)"\;
	@echo "minimal use NOCACHE=$(NOCACHE)"\;
	$(call generate_file,alpine,oc.template.alpine.minimal,oc.template.alpine.minimal)
	$(call generate_file,ubuntu:18.04,oc.template.ubuntu.minimal.18.04,oc.template.ubuntu.minimal)
	$(call generate_file,ubuntu:20.04,oc.template.ubuntu.minimal.20.04,oc.template.ubuntu.minimal)
	$(call generate_file,ubuntu:22.04,oc.template.ubuntu.minimal.22.04,oc.template.ubuntu.minimal)
	$(call generate_file,debian:stable-slim,oc.template.debian.minimal,oc.template.ubuntu.minimal)

level0:
	# build oc.template
	@echo "----------------------------"
	@echo "--- make level0 template ---"
	@echo "----------------------------"
	$(call generate_file,abcdesktopio/oc.template.alpine.minimal,oc.template.alpine,oc.template.alpine)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.minimal.18.04,oc.template.ubuntu.18.04,oc.template.ubuntu)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.minimal.20.04,oc.template.ubuntu.20.04,oc.template.ubuntu)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.minimal.22.04,oc.template.ubuntu.22.04,oc.template.ubuntu)
	$(call generate_file,abcdesktopio/oc.template.debian.minimal,oc.template.debian,oc.template.ubuntu)
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine.minimal        -t abcdesktopio/oc.template.alpine:$(TAG)             -f oc.template.alpine .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.18.04  -t abcdesktopio/oc.template.ubuntu.18.04:$(TAG)  		-f oc.template.ubuntu .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.20.04  -t abcdesktopio/oc.template.ubuntu.20.04:$(TAG)  		-f oc.template.ubuntu .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.minimal.22.04  -t abcdesktopio/oc.template.ubuntu.22.04:$(TAG)  		-f oc.template.ubuntu .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian.minimal        -t abcdesktopio/oc.template.debian:$(TAG) -f oc.template.ubuntu .

gtk:
	# build gtk
	#
	@echo "----------------"
	@echo "--- make gtk ---"
	@echo "----------------"
	$(call generate_file,abcdesktopio/oc.template.debian,oc.template.debian.gtk,oc.template.ubuntu.gtk)
	$(call generate_file,abcdesktopio/oc.template.alpine,oc.template.alpine.gtk,oc.template.alpine.gtk)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.18.04,oc.template.ubuntu.gtk.18.04,oc.template.ubuntu.gtk)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.20.04,oc.template.ubuntu.gtk,oc.template.ubuntu.gtk)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.20.04,oc.template.ubuntu.gtk.20.04,oc.template.ubuntu.gtk)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.22.04,oc.template.ubuntu.gtk.22.04,oc.template.ubuntu.gtk)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.gtk,oc.template.ubuntu.gtk.language-pack-all,oc.template.ubuntu.gtk.language-pack-all)
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.20.04  -t abcdesktopio/oc.template.ubuntu.gtk:$(TAG) -f oc.template.ubuntu.gtk .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.debian 	    -t abcdesktopio/oc.template.debian.gtk:$(TAG) -f oc.template.ubuntu.gtk .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine        -t abcdesktopio/oc.template.alpine.gtk:$(TAG) -f oc.template.alpine.gtk .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.18.04  -t abcdesktopio/oc.template.ubuntu.gtk.18.04:$(TAG)  	-f oc.template.ubuntu.gtk .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.20.04  -t abcdesktopio/oc.template.ubuntu.gtk.20.04:$(TAG)    	-f oc.template.ubuntu.gtk .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk    -t abcdesktopio/oc.template.ubuntu.gtk.language-pack-all:$(TAG) -f oc.template.ubuntu.gtk.language-pack-all .

# remove the first .
level1:
	echo "level1 use TAG=$(TAG)"\;
	$(call generate_file,abcdesktopio/oc.template.alpine,oc.template.alpine.libreoffice,oc.template.alpine.libreoffice)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.gtk.20.04,oc.template.ubuntu.gtk.java,oc.template.ubuntu.gtk.java)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.gtk.20.04,oc.template.ubuntu.gtk.libreoffice,oc.template.gtk.libreoffice)
	$(call generate_file,abcdesktopio/oc.template.ubuntu.22.04,oc.template.ubuntu.wine,oc.template.ubuntu.wine)
	# docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine 	-t abcdesktopio/oc.template.alpine.libreoffice:$(TAG) -f oc.template.alpine.libreoffice .
	# docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk.20.04 -t abcdesktopio/oc.template.ubuntu.gtk.java:$(TAG) -f oc.template.ubuntu.gtk.java .
	# docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.gtk.20.04 -t abcdesktopio/oc.template.ubuntu.gtk.libreoffice:$(TAG) 		-f oc.template.gtk.libreoffice .
	# docker build $(PROXY) $(NOCACHE) --build-arg  TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.22.04   -t abcdesktopio/oc.template.ubuntu.wine:$(TAG) -f oc.template.ubuntu.wine .

level2:
	echo "level2 use TAG=$(TAG)"\;
	$(call generate_file,abcdesktopio/oc.template.ubuntu.wine.22.04,oc.template.ubuntu.wine.mswindow,oc.template.ubuntu.wine.mswindows)
	$(call generate_file,abcdesktopio/oc.template.alpine.minimal,oc.template.alpine.wine,oc.template.alpine.wine)
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.ubuntu.wine.22.04  -t abcdesktopio/oc.template.ubuntu.wine.mswindows:$(TAG) -f oc.template.ubuntu.wine.mswindows .
	# docker build $(PROXY) $(NOCACHE) --build-arg TAG=$(TAG) --build-arg BASE_IMAGE=abcdesktopio/oc.template.alpine.minimal -t abcdesktopio/oc.template.alpine.wine:$(TAG) -f oc.template.alpine.wine .

push:
	for i in oc.template.alpine oc.template.ubuntu.18.04 oc.template.ubuntu.20.04 oc.template.ubuntu.22.04 oc.template.debian oc.template.alpine.gtk oc.template.ubuntu.gtk.18.04 oc.template.ubuntu.gtk.20.04 oc.template.ubuntu.gtk oc.template.debian.gtk oc.template.ubuntu.gtk.language-pack-all oc.template.alpine.libreoffice oc.template.ubuntu.gtk.java oc.template.ubuntu.gtk.libreoffice oc.template.ubuntu.wine oc.template.alpine.wine oc.template.ubuntu.wine.mswindows ; do \
		echo pushing abcdesktopio/$$i:$(TAG) ; \
        docker push abcdesktopio/$$i:$(TAG); \
    done

ai:
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.fulldev.ia:$(TAG) -f oc.template.gtk.fulldev.ia

devto30:
	for i in oc.template.alpine oc.template.ubuntu.18.04 oc.template.ubuntu.20.04 oc.template.ubuntu.22.04 oc.template.debian oc.template.alpine.gtk oc.template.ubuntu.gtk.18.04 oc.template.ubuntu.gtk.20.04 oc.template.ubuntu.gtk oc.template.debian.gtk oc.template.ubuntu.gtk.language-pack-all oc.template.alpine.libreoffice oc.template.ubuntu.gtk.java oc.template.ubuntu.gtk.libreoffice oc.template.ubuntu.wine oc.template.alpine.wine oc.template.ubuntu.wine.mswindows ; do \
		echo $$i ; \
		docker tag abcdesktopio/$$i:dev abcdesktopio/$$i:3.0 ; \
    done


clean:
	for i in oc.template.alpine oc.template.ubuntu.18.04 oc.template.ubuntu.20.04 oc.template.ubuntu.22.04 oc.template.debian oc.template.alpine.gtk oc.template.ubuntu.gtk.18.04 oc.template.ubuntu.gtk.20.04 oc.template.ubuntu.gtk oc.template.debian.gtk oc.template.ubuntu.gtk.language-pack-all oc.template.alpine.libreoffice oc.template.ubuntu.gtk.java oc.template.ubuntu.gtk.libreoffice oc.template.ubuntu.wine oc.template.alpine.wine oc.template.ubuntu.wine.mswindows ; do \
    	echo $$i ; \
		docker rmi abcdesktopio/$$i:$(TAG) ; \
    done
