#!/bin/bash

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)
cd $SCRIPT_DIR

function die() {
    echo "$1"
    exit 1
}

USAGE_MESSAGE=$(cat <<-EndOfMessage
Usage: $0 --dir SERVER_DIRECTORY --version VERSION [OPTIONAL_ARGS]
    -h | --help                     Print this message and exit.
    -d | --dir SERVER_DIRECTORY     Target given directory as server directory.
    -v | --version VERSION          Use given JE version to find server jar file,
                                    '1.20' for example.
    --Xmx MAX_MEMORY                Same as 'java --Xmx' option. 3G for default.
    --Xms MIN_MEMORY                Same as 'java --Xms' option. 1G for default.
    --nohup                         Run server on background with 'nohup'.
EndOfMessage
)

function usage() {
    die "$USAGE_MESSAGE"
}

if [[ $# -lt 1 ]]; then
    usage
elif ! command -v java &> /dev/null; then
    die "Java not found"
fi

# https://davetang.org/muse/2023/01/31/bash-script-that-accepts-short-long-and-positional-arguments/
OPTS=$(getopt -o h,v:,d:, --long help,dir:,Xmx:,Xms:,version:,nohup -- "$@")

Xmx="3G"
Xms="1G"
USE_NOHUP=false

eval set -- "$OPTS"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -h | --help)
            usage
            shift 1
            ;;
        -d | --dir)
            SERVER_NAME=$2
            shift 2
            ;;
        --Xmx)
            Xmx=$2
            shift 2
            ;;
        --Xms)
            Xms=$2
            shift 2
            ;;
        -v | --version)
            VERSION=$2
            shift 2
            ;;
        --nohup)
            USE_NOHUP=true
            shift 1
            ;;
        *)
            break
    esac
done

if [ -z ${SERVER_NAME+x} ]; then
    die "Server directory is not given. Use -d or --dir."
elif [ -z ${VERSION+x} ]; then
    die "JE version is not given. Use -v or --version."
elif [[ $SERVER_NAME == "server_archives" ]]; then
    die "\"server_archives\" as server directory is not allowed."
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
COMMAND="java -Xmx$Xmx -Xms$Xms -jar $JARFILE --nogui"

if [ "$USE_NOHUP" = "true" ]; then
    echo "Run \"pkill java\" to terminate the server."
    nohup $COMMAND >/dev/null 2>&1 &
else
    $COMMAND
fi
