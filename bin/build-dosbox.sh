#!/bin/bash -i

SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") &> /dev/null && pwd)"
cd ${SCRIPT_DIR}

. inc/finddosbox.sh

cd ..

mkdir -p build

echo -n "Building... "
${DBOX_CMD} -conf bin/conf/dosbox.linux.conf -noconsole -exit -c "BIN\BUILD\DOS.BAT" 2>&1 >/dev/null && { echo "done"; } || { echo "failed"; echo "Press any key to continue..."; read -n 1 -s; exit 1; }
