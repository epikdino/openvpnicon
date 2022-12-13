#!/bin/bash
set -e

SERVICE_NAME=$1
DESKTOP_PATH=$2
ACTION=$4

update_icon(){
	STATE="$(systemctl show -p SubState --value $1)"
	ICON="${STATE}.png"
	ACTUAL=$(grep 'Icon=' $2 | awk -F_ '{print $NF}' )
	echo $ICON
	echo $ACTUAL
	sed -i "s/$ACTUAL/$ICON/g" "$2"	
}

if  [ "$4" == "update" ]; then
	update_icon ${SERVICE_NAME} ${DESKTOP_PATH}
	exit 0
fi

#check state of service

STATE="$(systemctl show -p SubState --value $1)"
if [ "${STATE}" != "running" ]; then
	systemctl start ${SERVICE_NAME}
else
	systemctl stop ${SERVICE_NAME}
fi

update_icon ${SERVICE_NAME} ${DESKTOP_PATH}
