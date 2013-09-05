#!/bin/bash -e
#
# c9ftp-mirror.sh (c) Ajax.org B.V.

FTP_COMMAND="$1"
FTP_INCREMENTAL="$2"
FTP_DELETE="$3"
FTP_USERNAME="$4"
FTP_PASSWORD="$5"
FTP_PORT="$6"
FTP_LOCAL="$7"
FTP_REMOTE="$8"
FTP_HOST="$9"

if [ $FTP_DELETE == 1 ]; then
  FTP_DELETE=-e
else
  FTP_DELETE=
fi

if [ $FTP_INCREMENTAL != 1 ]; then
  rm -f /tmp/.c9ftp.marker
fi

source ~/etc/environment &> /dev/null || :

# TODO: nicer way of killing existing lftps?
killall lftp 2>/dev/null || :

echo > /tmp/.c9ftp-new.marker

(   echo Connecting

    if [ "$FTP_COMMAND" == "localToFTP" ]; then
        FTP_MIRROR_OPTS="-R \"$FTP_LOCAL\" \"$FTP_REMOTE\""
    else
        FTP_MIRROR_OPTS="\"$FTP_REMOTE\" \"$FTP_LOCAL\""
    fi

    # set ftp:port-range 15001-35530;
    `[ $(uname) == "Darwin" ] || echo stdbuf -oL` \
    lftp -u "$FTP_USERNAME","$FTP_PASSWORD" -p $FTP_PORT -e "
        set ftp:bind-data-socket false;
        set ftp:passive-mode true;
        set ssl:check-hostname false;
        set ssl:verify-certificate false;
        set net:max-retries 1;
        set net:timeout 30;
        debug 1;
        reconnect;
        (cd \"$FTP_REMOTE\" || mkdir \"$FTP_REMOTE\");
        mirror -c -P 2 $FTP_MIRROR_OPTS;
        exit" $FTP_HOST || (echo -e "\n\nFTP deployment failed. Please check your settings, and make sure you use a modern server that supports PASV mode."; exit 1)
 
    if [ "$FTP_COMMAND" == "localToFTP" ]; then
        mv /tmp/.c9ftp-new.marker /tmp/.c9ftp.marker &> /dev/null
    fi

    echo FTP Synchronization finished

) 2>&1 |
    `[ $(uname) == "Darwin" ] || echo stdbuf -oL` \
    sed -l -E 's/^(lftp|mirror):/ftp:/;
               s/^cd: Access failed: 550 Failed to change directory./Created remote directory/;
               s/^To be removed: .*//;
               s/^---- Address returned by PASV seemed to be incorrect and has been fixed//' |
   `[ $(uname) == "Darwin" ] || echo stdbuf -oL` \
   tee /tmp/.c9ftp.log
