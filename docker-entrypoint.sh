#!/bin/bash

set -e

umask u+rxw,g+rwx,o-rwx


ls -la /

#
# GENERATE CLUSTER CONF
#
env | j2  --format=env /work-private/cluster.properties.jinja2 > /jira-home/cluster.properties

#
# RECREATE DBCONFIG
#
cp /work-private/dbconfig.xml /jira-home/


exec "$@"
