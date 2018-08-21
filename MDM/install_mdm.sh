#!/bin/bash

# update silent install file based on arguments

sed -e "s|###MDM_INSTALL_LOCATION###|$MDM_INSTALL_LOCATION|g" $WORK_DIR/mdm_silent_install.xml

# install MDM
