#!/usr/bin/env bash

# MARKDOWN_PATH="${HOME}/demo"
# NOTE: 

if [ -z "${MARKDOWN_PATH}" ];then
   echo "{ \"items\":[{\"type\": \"error\",\"title\": \"请先设置文档路径 MARKDOWN_PATH \"}]}"
   exit 1
fi

# echo "${MARKDOWN_PATH}"
