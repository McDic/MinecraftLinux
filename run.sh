#!/bin/bash

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
cd $SCRIPT_DIR

OPTS=$(getopt --longoptions Xmx,Xms --name "$0" -- "$@" &> /dev/null)

function die() {
    echo "$1"
    exit 1
}

if [[ $# -lt 1 ]]; then
    die "Usage: $0 SERVER_NAME [--version VERSION] [--Xmx MAX_MEMORY] [--Xms MIN_MEMORY]"
elif ! command -v java &> /dev/null; then
    die "Java not found"
fi

SERVER_NAME=$1
shift 2

VERSION="1.20"
Xmx="1536M"
Xms="1024M"

while true; do
    case "$0" in
        --Xmx)
            Xmx=$1
            shift 2
            ;;
        --Xms)
            Xms=$1
            shift 2
            ;;
        --version)
            VERSION=$1
            shift 2
            ;;
        *)
            break
    esac
done

if [[ $SERVER_NAME == "server_archives" ]]; then
    die "\"server_archives\" as server_name is not allowed."
elif [[ ! -d "$SCRIPT_DIR/$SERVER_NAME" ]]; then
    die "Server directory $SCRIPT_DIR/$SERVER_NAME does not exist."
fi

JARFILE=$(ls "$SCRIPT_DIR/$SERVER_NAME" | grep ".*$VERSION.*.jar" | head -1)

if [[ ! $JARFILE ]]; then
    die "Couldn't find \"$VERSION\" version of java server file in the server directory."
fi

if [[ ! -f "$SCRIPT_DIR/$SERVER_NAME/eula.txt" ]]; then
    echo "Copying prepared EULA file.."
    cp "$SCRIPT_DIR/server_archives/eula_copy.txt" "$SCRIPT_DIR/$SERVER_NAME/eula.txt"
fi

cd $SERVER_NAME
java -Xmx$Xmx -Xms$Xms -jar $JARFILE nogui
