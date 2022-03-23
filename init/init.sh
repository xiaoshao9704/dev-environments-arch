#!/bin/sh

init_dir=$(cd `dirname $0` && pwd -P)

echo "init_at:${init_dir}"

if [[ -f "${init_dir}/done" ]]
then 
    echo "Already initialized"
elif  [[ -f "${init_dir}/initializing" ]]
then
    echo "initializing"
else 
    touch "${init_dir}/initializing"
    echo "init start"
    # 初始化git用户
    if [[ "${GIT_NAME}" != "" && "${GIT_EMAIL}" != "" ]];
    then
        echo "set git config start"
        git config --global user.name ${GIT_NAME}
        git config --global user.email ${GIT_EMAIL}
        echo "set git config done"
    fi
    # SSH-KEY 配置
    if [[ ! -f  ~/.ssh/id_rsa.pub && ! -f ~/.ssh/id_rsa && -f ${GIT_RSA} && -f ${GIT_RSA_PUB} ]]
    then
        echo "set ssh key start"
        mkdir -p ~/.ssh
        cp ${GIT_RSA_PUB} ~/.ssh/id_rsa.pub
        cp ${GIT_RSA} ~/.ssh/id_rsa 
        chmod 600 ~/.ssh/id_rsa
        chmod 640 ~/.ssh/id_rsa.pub
        echo "set ssh key done"
    fi
    touch "${init_dir}/done"
    rm "${init_dir}/initializing"
    echo "init done"
fi

exec "$@"