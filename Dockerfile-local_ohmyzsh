# syntax=docker/dockerfile:1
FROM archlinux:latest

# 可以修改你的用户、基础home目录、初始安装的pkg
ARG USERNAME="vscode" HOME_BASE="/home" CUSTOM_PKGS=""
# 设定后首次启动时，会用于设置git/ssh
ENV GIT_EMAIL="" GIT_NAME="" GIT_RSA="" GIT_RSA_PUB=""

RUN echo "home_path:${HOME_BASE}/${USERNAME}" \
    && echo "custom_pkgs:${CUSTOM_PKGS}"

# 基础环境
RUN --mount=type=cache,sharing=locked,target=/var/cache/pacman \
    # 设置pacman源
    echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/\$repo/os/\$arch" >> /etc/pacman.d/mirrorlist.proxy \
    && mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak \
    && mv /etc/pacman.d/mirrorlist.proxy /etc/pacman.d/mirrorlist \
    # 设置archlinuxcn源
    && echo "[archlinuxcn]" >> /etc/pacman.conf \
    && echo "SigLevel = Never" >> /etc/pacman.conf \
    && echo "Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/\$arch" >> /etc/pacman.conf \
    # 更新仓库
    && pacman -Syu --noconfirm \
    && pacman -S --noconfirm archlinuxcn-keyring sudo base-devel inetutils openssh openssl yay zsh vim git supervisor ${CUSTOM_PKGS} \
    && useradd -m -s /bin/zsh -b ${HOME_BASE} -G wheel ${USERNAME} \
    # 设置用户sudo无密码
    && echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${USERNAME} \
    # 设置zsh
    && chsh -s /bin/zsh ${USERNAME}

# 切换用户
USER ${USERNAME}
# 移动到home目录
WORKDIR ${HOME_BASE}/${USERNAME}
ADD --chown=${USERNAME} ./init /init
ADD --chown=${USERNAME} https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh /init/install.sh
# 初始化
RUN --mount=type=cache,sharing=locked,target=/init \
    git config --global http.version HTTP/1.1 \
    && sh /init/install.sh --unattended \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting \
    && sed -i 's/(git)/(git zsh-autosuggestions zsh-syntax-highlighting)/g' ${HOME_BASE}/${USERNAME}/.zshrc \
    && rm /init/install.sh \
    && chmod +x /init/start.sh

ENTRYPOINT /init/start.sh
CMD sleep infinity