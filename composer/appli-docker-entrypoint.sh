#!/bin/bash

START_TIME=$EPOCHSECONDS


# Dump env APP ARG and APPARG to log file
# export VAR
export STDOUT_LOGFILE=/tmp/lastcmd.log
export STDOUT_ENVLOGFILE=/tmp/lastcmdenv.log
echo "start at EPOCHSECONDS=$START_TIME $(date)" >> $STDOUT_LOGFILE
echo "APP=$APP" >> $STDOUT_LOGFILE
echo "ARGS=$ARGS" >> $STDOUT_LOGFILE
echo "APPARGS=$APPARGS" >> $STDOUT_LOGFILE
env > $STDOUT_ENVLOGFILE
INIT_OVERLAY_PATH=/composer/init.overlay.d

echo "run previous init overlay stack" >> $STDOUT_LOGFILE
# Run init overlay script file if exist
if [ -d "$INIT_OVERLAY_PATH" ]; then
	for overlay_script in "INIT_OVERLAY_PATH/*.sh"
	do
		if [ -f $overlay_script -a -x $overlay_script ]
		then
			echo "run $overlay_script" >> $STDOUT_LOGFILE
			$overlay_script >> $STDOUT_LOGFILE
		fi
	done
fi
echo "init overlay script done at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE

echo "run init app if exists" >> $STDOUT_LOGFILE
# Run init APP if exist
BASENAME_APP=$(basename "$APPBIN")
echo "BASENAME_APP=$BASENAME_APP" >> $STDOUT_LOGFILE
SOURCEAPP_FILE=/composer/init.d/init.${BASENAME_APP}
if [ -f "$SOURCEAPP_FILE" ]; then
	echo "run /composer/init.d/init.${BASENAME_APP} $APPARGS" >> $STDOUT_LOGFILE
	$SOURCEAPP_FILE "$APPARGS" > /tmp/${BASENAME_APP}.cmd.log 2>&1
	echo "done /composer/init.d/init.${BASENAME_APP}" >> $STDOUT_LOGFILE
fi

echo "init app script done at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE

if [ ! -d ~/.cache ]; then
     mkdir  ~/.cache
fi

if [ -d /composer/.cache ]; then
	cp -nr /composer/.cache/* ~/.cache/
fi 

# .Xauthority
if [ ! -f ~/.Xauthority ]; then
	# create a MIT-MAGIC-COOKIE-1 entry in .Xauthority
	if [ ! -z "$XAUTH_KEY" ]; then
        	echo "xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $XAUTH_KEY" >> $STDOUT_LOGFILE
        	xauth add $DISPLAY MIT-MAGIC-COOKIE-1 $XAUTH_KEY >> $STDOUT_LOGFILE 2>&1
		echo "xauth add  done at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE
	fi
fi

# create a PULSEAUDIO COOKIE 
if [ ! -z "$PULSEAUDIO_COOKIE" ]; then
	echo "setting pulseaudio cookie" >> $STDOUT_LOGFILE
  	mkdir -p ~/.config/pulse
  	cat /etc/pulse/cookie | openssl rc4 -K "$PULSEAUDIO_COOKIE" -nopad -nosalt > ~/.config/pulse/cookie
	echo "pusleaudio cookie done at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE
fi

# start dbux-launch if exists
if [ -x /usr/bin/dbus-launch ]; then
	mkdir -p /run/user/$(id --user)/dconf
        export $(/usr/bin/dbus-launch)
	echo "dbus-launch done at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE
fi

echo "end of init at $(($EPOCHSECONDS - $START))" >> $STDOUT_LOGFILE
echo "running $APP at $(date)" >> $STDOUT_LOGFILE

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
# log the exit code in /tmp/lastcmd.log
echo "end of app exit_code=$EXIT_CODE" >> $STDOUT_LOGFILE
# exit with the application exit code 
exit $EXIT_CODE

