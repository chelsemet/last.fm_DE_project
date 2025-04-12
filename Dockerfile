FROM apache/airflow:2.8.1

USER root

# Install OpenJDK 17 (available in Debian Bookworm) instead of OpenJDK 11
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        default-jdk \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME for the default JDK
RUN JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java)))) \
    && echo "export JAVA_HOME=$JAVA_HOME" >> /home/airflow/.bashrc \
    && echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /home/airflow/.bashrc

# Set environment variables for this session
ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Switch back to airflow user
USER airflow