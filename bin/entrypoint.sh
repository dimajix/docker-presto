#!/bin/bash
set -eo pipefail

# Setup environment
source /opt/docker/libexec/common.sh
source /opt/docker/libexec/presto-init.sh


start_worker() {
   	$PRESTO_HOME/bin/launcher --config=${PRESTO_CONF_DIR}/worker-config.properties run "$@"
    check_java
}


start_coordinator() {
   	$PRESTO_HOME/bin/launcher --config=${PRESTO_CONF_DIR}/coordinator-config.properties run "$@"
    check_java
}


case "$1" in
    "coordinator")
        start_coordinator
        ;;
    "worker")
        start_worker
        ;;
    *)
        exec $@
        ;;
esac
exit $?
