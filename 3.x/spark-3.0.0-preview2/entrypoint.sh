#!/bin/bash

function echod(){
echo "`date +%H:%M:%S` : $1"
}

function check_port(){
PORT=$1
PROCESS_NAME=$2
netstat -peanut | grep ":$PORT "
EXIT_CODE=$?
until [ $EXIT_CODE -eq 0 ]; do
  sleep 0.2
  netstat -peanut | grep ":$PORT "
  EXIT_CODE=$?
done
echod "$PROCESS_NAME has started"
}

#Export the PATH
SUCCESS_FILE=$SPARK_HOME/conf/_SUCCESS
LOG_PATH=/opt/spark/logs
LOCAL_EVENTS=/opt/spark/events
SPARK_HDFS_EVENTS="hdfs://hadoop:9000/tmp/spark-events"
if [ ! -f $SUCCESS_FILE ]; then
            tar -xf /opt/spark.tar.gz -C /opt/
            mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark
            mkdir -p $LOG_PATH
fi


if [ ! -f $SUCCESS_FILE ]; then
  echod "Setting the spark configuration"
  mkdir -p $LOCAL_EVENTS

  echo "spark.eventLog.enabled true" >> $SPARK_HOME/conf/spark-defaults.conf
  echo "spark.driver.memory 1g" >> $SPARK_HOME/conf/spark-defaults.conf
  echo "spark.eventLog.dir file://$LOCAL_EVENTS" >> $SPARK_HOME/conf/spark-defaults.conf
  echo "spark.history.fs.logDirectory=$LOCAL_EVENTS" > $SPARK_HOME/conf/history.properties
  echo "Setup complete at $(date)" > $SPARK_HOME/conf/_SUCCESS
fi
  
  echod "Starting the spark master ${SPARK_VERSION} on the host : ${HOSTNAME}"
  nohup ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master \
  --host ${HOSTNAME} \
  --port 7077 \
  --webui-port 8080 &> $LOG_PATH/spark-master.log &
  
  check_port 8080 "Spark Master"

        #Start the slave
  echod "Starting the spark worker ${SPARK_VERSION} on the host : ${HOSTNAME}"
  ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker \
  --webui-port 8081 spark://${HOSTNAME}:7077 &> $LOG_PATH/spark-slave.log &

  check_port 8081 "Spark Worker"

echod "Starting the Spark History service"
nohup ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.history.HistoryServer \
--properties-file $SPARK_HOME/conf/history.properties &> $LOG_PATH/spark-history.log &
check_port 18080 "Spark History"

echod "[Service] : [Spark] has started"

exec "$@";

