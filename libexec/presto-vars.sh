#!/usr/bin/env bash
export PRESTO_ENVIRONMENT=${PRESTO_ENVIRONMENT=default}
export PRESTO_NODE_ID=${PRESTO_NODE_ID=$(uuid)}
export PRESTO_COORDINATOR_HOST=${PRESTO_COORDINATOR_HOST}
export PRESTO_PORT=${PRESTO_PORT=8080}

export PRESTO_DATA_DIR=${PRESTO_DATA_DIR=/var/presto/data}

# HDFS Settings
export HDFS_NAMENODE_HOSTNAME=${HDFS_NAMENODE_HOSTNAME=hadoop-namenode}

# Settings for accessing Hive
export HIVE_METASTORE_HOST=${HIVE_METASTORE_HOST=hive-metatore}
export HIVE_METASTORE_PORT=${HIVE_METASTORE_PORT=9083}

# S3 properties
export S3_PROXY_HOST=${S3_PROXY_HOST}
export S3_PROXY_PORT=${S3_PROXY_PORT}
export S3_PROXY_USE_HTTPS=${S3_PROXY_USE_HTTPS=false}
export S3_ENDPOINT=${S3_ENDPOINT=s3.amazonaws.com}
export S3_ENDPOINT_HTTP_PORT=${S3_ENDPOINT_HTTP_PORT=80}
export S3_ENDPOINT_HTTPS_PORT=${S3_ENDPOINT_HTTPS_PORT=443}

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
