dockertemplate= oc.template.gtk.18.04 oc.template.gtk oc.template.gtk.wine.50 oc.template.gtk.java oc.template.gtk.fulldev oc.template.gtk.java.eclipse oc.template.gtk.libreoffice oc.template.gtk.firefox.rest oc.template.gtk.postman oc.template.gtk.mswindows oc.template.gtk.java.sts4


CORE_COUNT=$(shell getconf _NPROCESSORS_ONLN) 

ifndef TAG
 TAG=dev
endif 


all:
	@echo Note: You can use the command make -j $(CORE_COUNT) to use all cores
	docker pull ubuntu:18.04
	docker pull ubuntu:20.04
	$(MAKE) removeexitedcontainer
	$(MAKE) cleandangling
	# do it twice
	$(MAKE) cleandangling
	echo "OPTIONBUILD_ARG=$(OPTIONBUILD_ARG)"\;
	$(MAKE) level0 OPTIONBUILD_ARG="$(OPTIONBUILD_ARG)"
	$(MAKE) level1
	$(MAKE) level2

octemplate%:
	echo abcdesktop/oc.template$* \;
	docker build $(OPTIONBUILD_ARG) --build-arg TAG=$(TAG) -t abcdesktopio/oc.template$*:$(TAG) -f oc.template$* . 

level0: 
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.18.04:$(TAG) -f oc.template.gtk.18.04 .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk:$(TAG)   -f oc.template.gtk .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.language-pack-all:$(TAG) -f oc.template.gtk.language-pack-all .

# remove the first .
level1: octemplate.gtk.java octemplate.gtk.fulldev octemplate.gtk.java.eclipse octemplate.gtk.libreoffice octemplate.gtk.firefox octemplate.gtk.firefox.rest octemplate.gtk.wine.50 octemplate.gtk.gimagereader

#  octemplate.gtk.wine.50 
#
level2:
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.mswindows:$(TAG) -f oc.template.gtk.mswindows .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.java.sts4:$(TAG) -f oc.template.gtk.java.sts4 .
	docker build --build-arg TAG=$(TAG) -t abcdesktopio/oc.template.gtk.fulldev.vscode:$(TAG) -f oc.template.gtk.fulldev.vscode .

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
