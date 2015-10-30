#!/bin/bash

source config

echo "Now cloning Gearman web ui from "

git clone ${GEARMAN_WEB_UI_SOURCE} ${GEARMAN_WEB_UI_SOURCE_DOWNLOAD_DIR}
verify_command $? "Error cloning gearman-web-ui"

cd ${GEARMAN_WEB_UI_SOURCE_DOWNLOAD_DIR}/gearman-ui



