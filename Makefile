dockertemplate= oc.template.gtk.18.04 oc.template.gtk oc.template.gtk.wine.50 oc.template.gtk.java oc.template.gtk.fulldev oc.template.gtk.java.eclipse oc.template.gtk.libreoffice oc.template.gtk.firefox.rest oc.template.gtk.postman oc.template.gtk.mswindows oc.template.gtk.java.sts4


CORE_COUNT=$(shell getconf _NPROCESSORS_ONLN) 

#check-env:
#ifdef BUILD_ARG_PROXY_HTTPS
#	OPTIONBUILD_ARG += "--build-arg HTTPS_PROXY=$(BUILD_ARG_PROXY_HTTPS)" 
#endif 

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
	docker build $(OPTIONBUILD_ARG) -t abcdesktopio/oc.template$* -f oc.template$* . 

level0: 
	docker build $(OPTIONBUILD_ARG) -t abcdesktopio/oc.template.gtk.18.04 -f oc.template.gtk.18.04 .
	docker build $(OPTIONBUILD_ARG) -t abcdesktopio/oc.template.gtk -f oc.template.gtk .
	docker build $(OPTIONBUILD_ARG) -t abcdesktopio/oc.template.gtk.language-pack-all -f oc.template.gtk.language-pack-all .

# remove the first .
level1: octemplate.gtk.java octemplate.gtk.fulldev octemplate.gtk.java.eclipse octemplate.gtk.libreoffice octemplate.gtk.firefox octemplate.gtk.firefox.rest octemplate.gtk.wine.50 octemplate.gtk.gimagereader

#  octemplate.gtk.wine.50 
#
level2:
	docker build -t abcdesktopio:oc.template.gtk.mswindows -f oc.template.gtk.mswindows .
	docker build -t abcdesktopio:oc.template.gtk.java.sts4 -f oc.template.gtk.java.sts4 .
	docker build -t abcdesktopio:oc.template.gtk.fulldev.vscode -f oc.template.gtk.fulldev.vscode .

ai:
	docker build -t abcdesktopio:oc.template.gtk.fulldev.ia -f oc.template.gtk.fulldev.ia
push:
	for dir in $(dockertemplate); do \
                docker push abcdesktopio:$$dir ;\
        done 

cleandangling:
	docker rmi `docker images -q --filter "dangling=true"` || true


removeexitedcontainer:
	docker rm `docker ps -a -q -f "status=exited"` || true

clean:
	for dir in $(dockertemplate); do \
                docker rmi abcdesktopio/$$dir ;\
		docker rmi $$dir ;\
        done 
