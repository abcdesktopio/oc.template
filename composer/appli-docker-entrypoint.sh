#!/bin/bash

# Dump env APP ARG and APPARG to log file

echo "APP=$APP" >> /tmp/lastcmd.log
echo "ARGS=$ARGS" >> /tmp/lastcmd.log
echo "APPARGS=$APPARGS" >> /tmp/lastcmd.log

# export VAR
export DISPLAY=$DISPLAY
export PULSE_SERVER=/tmp/.pulse.sock
export USER=$BUSER
export LIBOVERLAY_SCROLLBAR=0
export UBUNTU_MENUPROXY=0
export HOME=/home/balloon
export LOGNAME=balloon
env > /tmp/lastcmdenv.log 

# Run init APP if exist
BASENAME_APP=$(basename "$APPBIN")
echo "BASENAME_APP=$BASENAME_APP" >> /tmp/lastcmd.log
SOURCEAPP_FILE=/composer/init.d/init.${BASENAME_APP}
if [ -f "$SOURCEAPP_FILE" ]; then
	echo "run /composer/init.d/init.${BASENAME_APP}" >> /tmp/lastcmd.log
	bash -x "$SOURCEAPP_FILE" > /tmp/${BASENAME_APP}.cmd.log 2>&1
	echo "done /composer/init.d/init.${BASENAME_APP}" >> /tmp/lastcmd.log
fi

if [ -f ~/.DBUS_SESSION_BUS ]; then
	source ~/.DBUS_SESSION_BUS
fi 

if [ ! -d ~/.cache ]; then
     mkdir  ~/.cache
fi


if [ -d /composer/.cache ]; then
        mkdir -p ~/.cache
	cp -nr /composer/.cache/* ~/.cache/
fi 

# Run the APP with args
if [ -z "$ARGS" ]; then    
	if [ -z "$APPARGS" ]; then  
		# $APPARGS is empty or unset 
		# $ARGS is empty or unset
		# no params
		${APP} 2>&1 | tee /tmp/$BASENAME_APP.log 
	else
		# $APPARGS is set 
                # $ARGS is empty or unset
                # APPARGS is the only param
		${APP} "${APPARGS}" 2>&1 | tee /tmp/$BASENAME_APP.log
	fi
else
	if [ -z "$APPARGS" ]; then  
                # $APPARGS is empty or unset 
                # $ARGS is set
                # $ARGS is the only param
                ${APP} ${ARGS} 2>&1 | tee /tmp/$BASENAME_APP.log
        else
		# $APPARGS is set 
                # $ARGS is set
                # use params: $ARGS and $APPARGS
                ${APP} ${ARGS} "${APPARGS}" 2>&1 | tee /tmp/$BASENAME_APP.log
        fi
fi
EXIT_CODE=$?
echo "end of app exit_code=$EXIT_CODE" >> /tmp/lastcmd.log


