#!/usr/bin/env bash
set -eo pipefail

# Setup environment
source /opt/docker/libexec/common.sh
source /opt/docker/libexec/presto-vars.sh

render_templates /opt/docker/conf/presto $PRESTO_CONF_DIR
