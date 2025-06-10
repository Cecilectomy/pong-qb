#!/bin/bash -i

echo -n "Looking for QB64... "

type qb64pe >/dev/null 2>&1 && export QB64_CMD="qb64pe"
type qb64 >/dev/null 2>&1 && export QB64_CMD="qb64"

if [[ -z ${QB64_CMD+x} ]]; then
    echo "not found!"
    echo "Press any key to continue..."; read -n 1 -s
    exit 1
else
    echo "found! (${QB64_CMD})"
fi
