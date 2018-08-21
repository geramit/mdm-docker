FROM mdm/was-85513:1.0

MAINTAINER Amit Gera <amit.gera@gmail.com>

ARG MDM_DB_HOST=MDMDBHost
ARG DB_PORT=1521
ARG MDM_DB_NAME=MDMDB
ARG MDM_DB_USER=mdm
ARG MDM_DB_USER_PWD=Ev*luti*n04
ARG CELL_NAME=DefaultCell01
ARG PROFILE_NAME=AppServer01
ARG NODE_NAME=DefaultNode01
ARG SERVER_NAME=server1
ARG WAS_ADMIN_USER=wasadmin
ARG WAS_ADMIN_USER_PASSWORD=wasadmin
ARG MDM_ADMIN_USER=mdmadmin
ARG MDM_ADMIN_USER_PASSWORD=mdmadmin
ARG MDM_INSTALL_LOCATION=/app/InfoSphere/MDM
ARG ORA_CLIENT_INSTALL_LOCATION=/app/oraclient

ENV HOST_NAME=localhost

USER root

# Copy required files
COPY *.sh *.py mdm_silent_install.xml soap.client.props client_install.rsp tnsnames.ora $WORK_DIR/

RUN chmod 755 $WORK_DIR/*.sh && chown $USER:$GROUP $WORK_DIR/*

USER $USER

# Install Oracle client
RUN wget -q http://$WEB_SERVER/linuxamd64_12102_client.zip -O /tmp/ora_client.zip \
    && mkdir /tmp/ora_client \
    && unzip -qd /tmp/ora_client /tmp/ora_client.zip && rm /tmp/ora_client.zip \
    && /tmp/ora_client/client/runInstaller -silent -force -waitforcompletion -responseFile $WORK_DIR/client_install.rsp -ignoresysprereqs -ignoreprereq \
    && rm -fr /tmp/ora_client /tmp/Oracle*

# Create profile and server
# TODO: change to use a response file, convert to shell script
RUN manageprofiles.sh -create -profileName $PROFILE_NAME \
    -profilePath $VAR_WEBSPHERE/profiles/$PROFILE_NAME  \
    -templatePath $APP_WEBSPHERE/profileTemplates/default \
    -nodeName $NODE_NAME -cellName $CELL_NAME -hostName $HOST_NAME \
    -serverName $SERVER_NAME -enableAdminSecurity true -adminUserName $WAS_ADMIN_USER -adminPassword $WAS_ADMIN_USER_PASSWORD

# Copy soap.client.props
RUN mv $WORK_DIR/soap.client.props $VAR_WEBSPHERE/profiles/$PROFILE_NAME/properties

# Install MDM
RUN wget -q http://$WEB_SERVER/MDM_STD_ADV_11.5_ML_1.zip -O /tmp/mdm1.zip && unzip -qd /tmp /tmp/mdm1.zip && rm /tmp/mdm1.zip \
	&& wget -q http://$WEB_SERVER/MDM_STD_ADV_11.5_ML_2.zip -O /tmp/mdm2.zip && unzip -qd /tmp /tmp/mdm2.zip && rm /tmp/mdm2.zip \
	&& wget -q http://$WEB_SERVER/MDM_STD_ADV_11.5_ML_3.zip -O /tmp/mdm3.zip && unzip -qd /tmp /tmp/mdm3.zip && rm /tmp/mdm3.zip \
	&& wget -q $URL/MDM_STD_ADV_11.5_ML_4.zip -O /tmp/mdm4.zip && unzip -qd /tmp /tmp/mdm4.zip && rm /tmp/mdm4.zip \
	&& wget -q $URL/11.5.0.5-MDM-SAE-FP05IF000.zip -O /tmp/fp05.zip && unzip -qd /tmp/MDM/FP05 /tmp/fp05.zip && rm /tmp/fp05.zip \
    && $APP_IM/eclipse/IBMIM -silent -input $WORK_DIR/mdm_silent_install.xml -acceptLicense -nosplash \
    && rm -rf /tmp/MDM

EXPOSE 2809 8880 9060 9080 9443 9043

#HEALTHCHECK

CMD "$WORK_DIR/manage_server.sh"
