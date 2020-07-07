FROM python:3.8

# Update linux to a more robust version
RUN apt update  \
    && apt install -y libaio1 \
    && rm -rf /var/lib/apt/lists/*

# Install any needed packages specified in code or requirements.txt
RUN pip install -U pip
RUN pip install records cx_Oracle bbrest tablib[pandas] python-dotenv pandas msal requests hvplot jupyterlab
# Copy the linux based oracle zip file into the container at /app
COPY  instant_client_19_6.zip /
# Unzip the linux based Oracle client into the container
RUN unzip /instant_client_19_6.zip -d /oracle

# Define environment variable
ENV ORACLE_HOME /oracle/instantclient_19_6
ENV TNS_ADMIN ./network/admin
ENV LD_LIBRARY_PATH /oracle/instantclient_19_6:$LD_LIBRARY_PATH
RUN rm -r instant_client_19_6.zip
# Seems to work, exits with a status of 0