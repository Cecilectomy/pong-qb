#!/bin/bash -i

SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") &> /dev/null && pwd)"
cd ${SCRIPT_DIR}

. inc/findqb64.sh

cd ..

mkdir -p build

${QB64_CMD} || { echo "failed"; echo "Press any key to continue..."; read -n 1 -s; exit 1; }
