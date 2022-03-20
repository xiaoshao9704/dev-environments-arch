#!/bin/sh

if [[ ! -f "${HOME_BASE}/${USERNAME}/init/done" ]]
then
    # 初始化git用户
    if [[ "${GIT_NAME}" != "" && "${GIT_EMAIL}" != "" ]];
    then
        git config --global user.name ${GIT_NAME}
        git config --global user.email ${GIT_EMAIL}
    fi
    # SSH-KEY 配置
    if [[ ! -d ~/.ssh && -f ${GIT_RSA} && -f ${GIT_RSA_PUB} ]];
    then
        mkdir -p ~/.ssh
        cp ${GIT_RSA_PUB} ~/.ssh/id_rsa.pub
        cp ${GIT_RSA} ~/.ssh/id_rsa
    fi
    # 自定义包安装
    if [[ "${CUSTOM_PKG}" != "" ]];
    then    
        yay -S --noconfirm ${CUSTOM_PKG}
    fi
    touch "${HOME_BASE}/${USERNAME}/init/done"
fi

sleep infinity