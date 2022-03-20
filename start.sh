#!/bin/sh

if [[ ! -f "${HOME_BASE}/${USERNAME}/.gitconfig" ]];
then
    git config --global user.name ${GIT_NAME} &&\
    git config --global user.email ${EMAIL} &&\
    mkdir -p ~/.ssh &&\
    echo ${GIT_RSA} > ~/.ssh/id_rsa &&\
    echo ${GIT_RSA_PUB} > ~/.ssh/id_rsa.pub
fi

sleep infinity