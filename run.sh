#!/bin/bash

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $SCRIPT_DIR

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 server_name version"
    exit 1
elif [[ $1 == "server_archives" ]]; then
    echo "\"server_archives\" as server_name is not allowed."
    exit 1
elif [[ ! -d "$SCRIPT_DIR/$1" ]]; then
    echo "Server directory $SCRIPT_DIR/$1 does not exist."
    exit 1
fi

JARFILE=$(ls "$SCRIPT_DIR/$1" | grep ".*$2.*.jar" | head -1)

if [[ ! $JARFILE ]]; then
    echo "Couldn't find \"$2\" version of java server file in the server directory."
    exit 1
fi

if [[ ! -f "$SCRIPT_DIR/$1/eula.txt" ]]; then
    echo "Copying prepared EULA file.."
    cp "$SCRIPT_DIR/server_archives/eula_copy.txt" "$SCRIPT_DIR/$1/eula.txt"
fi

cd $1 && java -Xmx1536M -Xms512M -jar $JARFILE nogui
