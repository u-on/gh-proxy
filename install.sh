#!/bin/bash

# pip install -i https://mirrors.aliyun.com/pypi/simple/ -r ./requirements.txt

SOURCE="$0"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

# apt install -y build-essential zlib1g-dev libncurses5-dev libncursesw5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev llvm xz-utils tk-dev liblzma-dev libgdbm-compat-dev

pyenv versions | grep -wi "[[:blank:]]*3.9.7$"
if [ $? != 0 ]; then

  pyenv install --list
  pyenv install 3.9.7 || (echo Python 安装失败！ && exit 1)

fi

# pyenv uninstall env-3.9.7-gh-proxy
pyenv virtualenv 3.9.7 env-3.9.7-gh-proxy

cat >"${DIR}/.python-version" <<EOF
env-3.9.7-gh-proxy
EOF

pip install --upgrade pip
pip install -r ./requirements.txt

PYENVPATH="/root/.pyenv/versions/3.9.7/envs/env-3.9.7-gh-proxy/bin"

if [ -f "/etc/systemd/system/gh-proxy.service" ]; then
  systemctl disable gh-proxy
  systemctl stop gh-proxy
  rm -f "/etc/systemd/system/gh-proxy.service"
fi

cat >"${DIR}/gh-proxy.service" <<EOF
[Unit]
Description=Prometheus
After=network-online.target

[Service]
WorkingDirectory=${DIR}
Environment="PATH=${PYENVPATH}"
ExecStart=${PYENVPATH}/gunicorn -c gunicorn.py app:app >log.txt 2>&1 &
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

ln -s -f "${DIR}/gh-proxy.service" "/etc/systemd/system/gh-proxy.service"

systemctl enable gh-proxy
systemctl start gh-proxy
