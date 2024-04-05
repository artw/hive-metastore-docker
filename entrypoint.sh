if [ "$LOGLEVEL" == "" ]; then
  LOGLEVEL=INFO
fi

METASTORE_PORT=9083
export PATH=$PATH:/opt/hive/bin
hive --service metastore --hiveconf hive.root.logger=${LOGLEVEL},console
