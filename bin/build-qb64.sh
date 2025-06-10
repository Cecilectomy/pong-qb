#!/bin/bash -i

SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") &> /dev/null && pwd)"
cd ${SCRIPT_DIR}

. inc/findqb64.sh

cd ..

mkdir -p build

echo -n "Building... "
${QB64_CMD} -c pong.qb64.bas -o build/PONG.QB64.EXE 2>&1 >/dev/null && { echo "done"; } || { echo "failed"; echo "Press any key to continue..."; read -n 1 -s; exit 1; }
