#!/bin/bash

#Set Script Name variable
SCRIPT=`basename ${BASH_SOURCE[0]}`

#Initialize variables to default values.
# init.sh "  width + " " + height + " "
# Set default mode to Full HD 
OPT_LOCAL=""


## Export Var
export LIBOVERLAY_SCROLLBAR=0
export UBUNTU_MENUPROXY=
export DISPLAY=:0
export HOME=/home/balloon
export LOGNAME=balloon
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"
export USER=balloon
export PULSE_SERVER=/tmp/.pulse.sock
export ABCDESKTOP_RUN_DIR='/composer/run'


# Note that '/home/balloon/.local/share' is not in the search path
# set by the XDG_DATA_HOME and XDG_DATA_DIRS
# environment variables, so applications may not be able to find it until you set them. The directories currently searched are:
#
# - /root/.local/share
# - /usr/local/share/
# - /usr/share/




DEFAULT_VNC_PASSWD="111111"

showHelp() {
cat << EOF
Usage: $0 [-hv]
docker-entrypoint.sh script to start docker application

-h, -help,          --help                  Display help
-v, -vncpassword,   --vncpassword           Vnc Password to connect VNC server

EOF
}

options=$(getopt -l "help,vncpassword:" -o "hv:" -a -- "$@")

# set --:
# If no arguments follow this option, then the positional parameters are unset. Otherwise, the positional parameters
# are set to the arguments, even if some of them begin with a ‘-’.
eval set -- "$options"

while [[ $1 != -- ]]; do
case $1 in
-h|--help)
    showHelp
    exit 0
    ;;
-v|--vncpassword)
    DEFAULT_VNC_PASSWD=$2
    shift 2;
    ;;
esac
done


# First start
# Clean lock 
rm -rf /tmp/.X0-lock

mkdir ${ABCDESKTOP_RUN_DIR}/.vnc
echo "${DEFAULT_VNC_PASSWD}" | vncpasswd -f > ${ABCDESKTOP_RUN_DIR}/.vnc/passwd

# Directory copy if not exist
if [ ! -L ~/.PlayOnLinux ]; then
	ln -s /composer/.PlayOnLinux /home/balloon/.PlayOnLinux 
fi

if [ ! -d ~/.cache ]; then
        mkdir ~/.cache
fi

if [ ! -f ~/.Xauthority ]; then
	touch ~/.Xauthority
fi

if [ ! -d ~/.printer-queue ]; then
	mkdir ~/.printer-queue
fi

#if [ ! -d ~/.logs ]; then
#	mkdir ~/.logs
#	chown -R balloon:balloon ~/.logs
#fi

if [ ! -d ~/.store ]; then  
	mkdir ~/.store
fi


if [ ! -d ~/Desktop ]; then
        mkdir ~/Desktop
fi

if [ ! -d ~/.config ]; then
        mkdir -p ~/.config
        cp -r /composer/.config ~/.config
fi

if [ ! -d ~/.config/gtk-3.0 ]; then
        mkdir -p ~/.config/gtk-3.0
        cp -r /composer/.config/gtk-3.0 ~/.config/gtk-3.0
fi

if [ ! -f ~/.config/gtk-3.0/settings.ini ]; then
        cp /composer/.config/gtk-3.0/settings.ini ~/.config/gtk-3.0
fi

if [ ! -d ~/.config/nautilus ]; then
        mkdir -p ~/.config/nautilus
fi

# noused
#if [ ! -d ~/.config ]; then
#        cp -rp /composer/.config ~
#fi

if [ ! -d ~/.themes ]; then
	cp -rp /composer/.themes ~
fi

if [ ! -f ~/.gtkrc-2.0 ]; then
	cp -rp /composer/.gtkrc-2.0 ~
fi 

if [ ! -f ~/.xsettings ]; then
	cp -rp /composer/.xsettings ~
fi

if [ ! -d ~/.gconf ]; then
        cp -rp /composer/.gconf ~
fi

if [ ! -d ~/.gconf/apps ]; then
        cp -rp /composer/.gconf/apps ~/.gconf
        chmod -R 700 ~/.gconf/apps
fi

if [ ! -f ~/.Xressources ];  then
	cp -p /composer/.Xressources ~ 
fi

if [ ! -f ~/.bashrc ];  then
        cp -r /composer/.bashrc ~
fi

if [ ! -f ~/ntlm_auth ]; then
        cp -p /composer/ntlm_auth ~
fi

if [ ! -d ~/.wallpapers ]; then
  # add default wallpapers 
  mkdir ~/.wallpapers
  cp -rp /composer/wallpapers/* ~/.wallpapers
fi

mkdir -p ~/.local/share
mkdir -p ~/.local/share/applications           
mkdir -p ~/.local/share/applications/bin

if [ ! -d ~/.local/share/icons ]; then
  cp -rp /composer/icons ~/.local/share
fi

if [ ! -d ~/.local/share/mime ]; then
  cp -rp /composer/mime ~/.local/share
  update-mime-database ~/.local/share/mime > /var/log/desktop/update-mime-database.log &
fi


# INITFILES=/composer/init.d/*.sh
# for f in $INITFILES
# do
#   echo "Processing $f file...";
#   # take action on each file. $f store current file name
#   source $f
# done


echo `date` > ${ABCDESKTOP_RUN_DIR}/start.txt




## KERBEROS SECTION

if [ -f /var/secrets/desktop/kerberos/keytab ]; then
        export KRB5_CLIENT_KTNAME=/var/secrets/desktop/kerberos/keytab
fi

if [ -f /var/secrets/desktop/kerberos/krb5.conf ]; then
        export KRB5_CONFIG=/var/secrets/desktop/kerberos/krb5.conf
fi

if [ -f /var/secrets/desktop/kerberos/PRINCIPAL ]; then
        export USERPRINCIPALNAME=$(cat /var/secrets/desktop/kerberos/PRINCIPAL)
fi

if [ -f /var/secrets/desktop/kerberos/REALM ]; then
        export REALM=$(cat /var/secrets/desktop/kerberos/REALM)
fi

if [ ! -z "$USERPRINCIPALNAME" ] && [ ! -z "$REALM" ] && [ ! -z "$KRB5_CONFIG" ] && [ ! -z "$KRB5_CLIENT_KTNAME" ]; then
        kinit "$USERPRINCIPALNAME@$REALM" -k -t $KRB5_CLIENT_KTNAME &
fi


if [ ! -z "$KUBERNETES_SERVICE_HOST" ]; then
   echo "starting in kubernetes mode " >> /var/log/desktop/config.log
   echo "starting KUBERNETES_SERVICE_HOST is set to $KUBERNETES_SERVICE_HOST" >> /var/log/desktop/config.log
else
   # KUBERNETES_SERVICE_HOST must exist 
   # else supervisord return an error  
   KUBERNETES_SERVICE_HOST=''
   echo "starting in docker mode" >> /var/log/desktop/config.log
   echo "starting /composer/post-docker-entrypoint.sh in background" >> /var/log/desktop/config.log
   /composer/post-docker-entrypoint.sh &
fi

# export VAR to running procces
export KUBERNETES_SERVICE_HOST

echo `date` > ${ABCDESKTOP_RUN_DIR}/start.txt
CONTAINER_IP_ADDR=$(ip route get 1 | awk '{print $7;exit}')
echo "Container local ip addr is $CONTAINER_IP_ADDR"
export CONTAINER_IP_ADDR


# replace CONTAINER_IP_ADDR in listen for pulseaudio
sed -i "s/module-http-protocol-tcp/module-http-protocol-tcp listen=$CONTAINER_IP_ADDR/g" /etc/pulse/default.pa
sed -i "s/localhost:631/$CONTAINER_IP_ADDR:631/g" /etc/cups/cupsd.conf

# start supervisord
/usr/bin/supervisord --pidfile /var/run/desktop/supervisord.pid --configuration /etc/supervisord.conf 

t=1
while [ $t -le 10 ]
do
  xset q
  if [[ $? -eq 0 ]]; then
	break
  fi 
  echo "waiting for X $t/12"
  t=$(( $t + 1 ))
  sleep 1
done
echo "X11 should run after $t/12"

# force DISPLAY to local
DISPLAY=:0.0 source /composer/appli-docker-entrypoint.sh

# logout after the app
node /composer/node/occall/occall.js logout

# This is the end...
supervisorctl stop all

