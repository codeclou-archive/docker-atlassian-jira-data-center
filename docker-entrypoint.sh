#!/bin/bash

set -e

umask u+rxw,g+rwx,o-rwx


ls -la /

#
# NODE 1...n
#
echo ">> docker-entrypoint: extracting JIRA-HOME"
rm -rf /jira-home/* | true
tar xfvj /work-private/jira-home-8.3.0.tar.bz2 -C /jira-home/
chown -R worker:worker /jira-home

#
# NODE 1
#
if [[ "${NODE_NUMBER}" == "1" ]]
then

  echo ">> docker-entrypoint: extracting JIRA-SHARED-HOME"
  rm -rf /jira-shared-home/* | true
  tar xfvj /work-private/jira-shared-home-8.3.0.tar.bz2 -C /jira-shared-home/
  chown -R worker:worker /jira-shared-home
fi

#
# GENERATE CLUSTER CONF
#
env | j2  --format=env /work-private/cluster.properties.jinja2 > /jira-home/cluster.properties

#
# RECREATE DBCONFIG
#
cp /work-private/dbconfig.xml /jira-home/


exec "$@"
