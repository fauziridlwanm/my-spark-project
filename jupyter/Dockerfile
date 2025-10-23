# Start from the official PySpark notebook image
FROM jupyter/pyspark-notebook:latest

# Switch to root user to install software
USER root

# Install Java 8 (to match the Hadoop image)
RUN apt-get update && \
    apt-get install -y openjdk-8-jre-headless && \
    apt-get clean

# Download and install Hadoop clients
RUN curl -O https://archive.apache.org/dist/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz && \
    tar -xzvf hadoop-3.2.1.tar.gz && \
    mv hadoop-3.2.1 /usr/local/hadoop && \
    rm hadoop-3.2.1.tar.gz

# Set HADOOP environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Copy our custom HDFS configuration file
COPY core-site.xml $HADOOP_CONF_DIR/

# Add Hadoop libs to PySpark's classpath
ENV SPARK_DIST_CLASSPATH="$HADOOP_HOME/etc/hadoop:$HADOOP_HOME/share/hadoop/common/lib/*:$HADOOP_HOME/share/hadoop/common/*:$HADOOP_HOME/share/hadoop/hdfs/*:$HADOOP_HOME/share/hadoop/hdfs/lib/*:$HADOOP_HOME/share/hadoop/mapreduce/*:$HADOOP_HOME/share/hadoop/yarn/*:$HADOOP_HOME/share/hadoop/yarn/lib/*"

# --- PRE-INSTALL YOUR PYTHON LIBRARIES ---
RUN pip install --no-cache-dir "synapseml==0.9.4" xgboost scikit-learn

# Switch back to the default notebook user
USER $NB_UID
