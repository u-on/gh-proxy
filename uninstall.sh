#!/usr/bin/env bash

SOURCE="$0"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
# ${DIR}

if [ -f "/etc/systemd/system/gh-proxy.service" ]; then
  systemctl disable gh-proxy
  systemctl stop gh-proxy
  rm -f /etc/systemd/system/gh-proxy.service
fi

[ -f "${DIR}/.python-version" ] && rm -f "${DIR}/.python-version"

if pyenv virtualenvs | grep -wi "[[:blank:]]env-3.9.7-gh-proxy[[:blank:]]"; then

  echo yes | pyenv uninstall env-3.9.7-gh-proxy
fi
