#!/bin/bash -eu
# Download xmls lited at scc*.html.gz
#
# Usage:
# 1. Obtain scc*.html.gz from official site.
#    (Run download-html-gz.sh, or download archives from official site if old mjlogs.)
# 2. Run this script same folder.
#
# Note:
# This script can be interrupted and resumed.
# However, if you interrupt it, the file size will often become 0.
# You can check whether there are any files with size 0 by using the following command.
#
#   find . -type f -size 0

mkdir -p downloads

for gz_file in scc*.html.gz; do
  echo "Processing: ${gz_file}"

  # .*log=    -> ignore  for until log=
  # ([^"]+)   -> capture for until "
  # .*        -> ignore  for until tail
  ids="$(gunzip -dc ${gz_file} | grep "四鳳南喰赤－" | sed -E 's/.*log=([^"]+).*/\1/')"

  for id in ${ids}; do
    filename="./downloads/${id}.xml"

    if [ -e ${filename} ]; then
      if [  -s ${filename} ]; then
        echo "Exist: ${filename}"
        continue
      else
        echo "Exist: ${filename} but file size is 0, retrying download"
      fi
    fi

    echo "Download: ${filename}"
    curl -s http://tenhou.net/0/log/?${id} > $filename
  done
done
