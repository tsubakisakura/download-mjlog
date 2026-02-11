#!/bin/bash -u
# Usage:
# Move to xml dir, and run this script.
mkdir -p success
mkdir -p fail

for src in *.xml; do
    echo ${src}
    id="${src%.xml}"
    dst="${id}.json"

    sleep 0.5
    curl -s https://tenhou.net/5/mjlog2json.cgi?${id} > ${dst}
    if [ $? -ne 0 ]; then
        mv ${src} fail/
        mv ${dst} fail/
        continue
    fi

    grep -q -F '<mjloggm ver="2.3">' ${src}
    if [ $? -ne 0 ]; then
        mv ${src} fail/
        mv ${dst} fail/
        continue
    fi

    grep -q -F '"ver":2.3' ${dst}
    if [ $? -ne 0 ]; then
        mv ${src} fail/
        mv ${dst} fail/
        continue
    fi

    mv ${src} success/
    mv ${dst} success/
done
