#!/bin/sh

init_dir=$(cd `dirname $0` && pwd -P)

echo "init_at:${init_dir}"

if [[ -f "${init_dir}/done" ]]
then 
    # echo "initialized"
elif  [[ -f "${init_dir}/initializing" ]]
then
    echo "initializing"
else
    uuid=$(cat /proc/sys/kernel/random/uuid)
    echo $uuid >> ${init_dir}/initializing
    if [[ "${uuid}" != "$(cat ${init_dir}/initializing)" ]]
    then 
        echo "initializing"
    else
        echo "init start"
        # 初始化git用户
        if [[ "${GIT_NAME}" != "" && "${GIT_EMAIL}" != "" ]];
        then
            echo "set git config start"
            git config --global user.name ${GIT_NAME}
            git config --global user.email ${GIT_EMAIL}
            echo "set git config done"
        fi
        mv "${init_dir}/initializing" "${init_dir}/done"
        echo "init done"
    fi
fi

exec "$@"