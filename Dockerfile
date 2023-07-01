# 動作確認用イメージ
# https://devlights.hatenablog.com/entry/2022/01/24/073000

# syntax=docker/dockerfile:1-labs
FROM buildpack-deps:stable-scm AS brew

#---------------------------------------------
# BUILD ARGUMENTS
#---------------------------------------------
ARG UID=1000
ARG USERNAME=dev
ARG HOMEDIR=/home/${USERNAME}
ARG PKGS_ESSENTIAL="zip unzip bash-completion build-essential sudo file time less man-db"
ARG PKGS_EDITOR="vim exuberant-ctags"
ARG PKGS_LOCALE="tzdata locales"
ARG PKGS_UTILS="jq lsof iputils-ping net-tools ncat psmisc"

#---------------------------------------------
# ROOT OPERATIONS
#---------------------------------------------
USER root
# >>> Install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN <<EOF
        apt-get update -q
        apt-get install -yq --no-install-recommends ${PKGS_ESSENTIAL} ${PKGS_EDITOR} ${PKGS_LOCALE} ${PKGS_UTILS}
        apt-get clean -y
        rm -rf /var/cache/debconf/* /var/lib/apt/lists/* /tmp/* /var/tmp/*
EOF
ENV DEBIAN_FRONTEND=
# >>> Build locales
RUN <<EOF
        locale-gen ja_JP.UTF-8
        localedef -i ja_JP -c -f UTF-8 -A /usr/share/locale/locale.alias ja_JP.UTF-8
        ln -sf  /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
EOF
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ Asia/Tokyo
# >>> Create user with sudo permission
RUN <<EOF
        useradd -l -u ${UID} -G sudo -md ${HOMEDIR} -s /bin/bash -p ${USERNAME} ${USERNAME}
        sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
EOF
ENV HOME=${HOMEDIR}
WORKDIR $HOME

#---------------------------------------------
# NON-ROOT USER OPERATIONS
#---------------------------------------------
USER dev
# >>> Base settings
RUN <<EOF
        sudo echo "Running 'sudo' for dev: success"
        mkdir -p /home/dev/.bashrc.d
        (echo; echo "for i in \$(ls -A \$HOME/.bashrc.d/); do source \$HOME/.bashrc.d/\$i; done"; echo) >> /home/dev/.bashrc
EOF
# >>> Vim settings
RUN <<EOF
        git clone https://gist.github.com/1a16cd5b551fe4e76ae941abb658b893.git vim-config-files
        cp vim-config-files/.vimrc ${HOMEDIR}
        rm -rf vim-config-files
EOF
# >>> Homebrew settings
RUN <<EOF
        mkdir ~/.cache
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
EOF
ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/
ENV MANPATH="$MANPATH:/home/linuxbrew/.linuxbrew/share/man"
ENV INFOPATH="$INFOPATH:/home/linuxbrew/.linuxbrew/share/info"
ENV HOMEBREW_NO_AUTO_UPDATE=1

#---------------------------------------------
# MISC
#---------------------------------------------
WORKDIR /workspace
VOLUME /workspace
