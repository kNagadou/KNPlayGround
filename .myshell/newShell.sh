#!/bin/sh

if [ $# -ne 1 ]; then
        echo "シェルスクリプト名を指定 newShell sample.sh"
        exit 1
fi

~/.myShell/temp.sh > $1
chmod u+x $1
vi $1
