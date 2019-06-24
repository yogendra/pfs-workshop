FROM wernight/codiad

ADD pfs.linux /usr/local/bin/pfs
ADD init.sh /init.sh

ENV WS_USER user-01


VOLUME /code/workspace/.kube

RUN \
    set -e &&\
    chmod a+x /init.sh && \
    chmod a+x /usr/local/bin/pfs && \
    (cd /default-code; git pull --rebase) && \
    ln -sf /usr/share/zoneinfo/Asia/Singapore /etc/localtime && \
    curl -sLO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \    
    chmod a+x kubectl && \
    mv kubectl /usr/local/bin && \
    echo 'source <(kubectl completion bash)' >>~/.bashrc && \
    echo "/init.sh" >> $HOME/.bashrc && \
    apt-get update && \
    apt-get install -qqy wget unzip && \
    curl -sLO https://github.com/Andr3as/Codiad-CodeGit/archive/master.zip && \
    unzip master.zip  -d /default-code/plugins/ && rm -rf master && \
    curl -sLO https://github.com/daeks-archive/Codiad-GitAdmin/archive/master.zip && \
    unzip master.zip  -d /default-code/plugins/ && rm -rf master && \
    curl -sLO https://github.com/Fluidbyte/Codiad-Terminal/archive/master.zip && \
    unzip master.zip  -d /default-code/plugins/ && rm -rf master

