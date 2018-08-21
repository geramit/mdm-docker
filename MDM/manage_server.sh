#!/bin/bash

# Script to start & stop server1

start_server() {
   echo "Starting application server...."
	$VAR_WEBSPHERE/profiles/$PROFILE_NAME/bin/startServer.sh $SERVER_NAME
}

stop_server() {
   echo "Stopping application server...."
	$VAR_WEBSPHERE/profiles/$PROFILE_NAME/bin/stopServer.sh $SERVER_NAME -user $ADMIN_USER_NAME -password $ADMIN_USER_NAME
}

restart_server() {
   stop_server
   start_server
}

update_hostname() {
   wsadmin.sh -lang jython -conntype NONE -f $WORK_DIR/updateHostName.py $NODE_NAME `hostname`
   touch $WORK_DIR/hostnameupdated
}

# Set SIGINT handler
trap stop_server SIGINT

# Set SIGTERM handler
trap stop_server SIGTERM

# Set SIGKILL handler
trap stop_server SIGKILL

start_server || exit $?

if [ ! -d  "$VAR_WEBSPHERE/profiles/$PROFILE_NAME/installedApps/$CELL_NAME/MDM-native-E001.ear" ]; then

   echo "Configuring MDM...."
   cd /app/InfoSphere/MDM/mds/scripts \
   && ./madconfig.sh Configure_MasterDataManagement -DwasPwd=mdmadmin -DmdmAdminPassword=mdmadmin -DdbPwd=Password@123

fi

PID=$(ps -C java -o pid= | tr -d " ")
echo "###################################"
echo "Waiting for PID: $PID ...."
echo "###################################"

tail -F $VAR_WEBSPHERE/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemOut.log --pid $PID -n +0 &
tail -F $VAR_WEBSPHERE/profiles/$PROFILE_NAME/logs/$SERVER_NAME/SystemErr.log --pid $PID -n +0 >&2 &
while [ -e "/proc/$PID" ]; do
  sleep 1
done
