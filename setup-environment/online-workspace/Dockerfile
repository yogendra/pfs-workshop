FROM wernight/codiad

ADD pfs.linux /usr/local/bin/pfs
ADD init.sh /init.sh

ENV WS_USER user-01


VOLUME /code/workspace/.kube

RUN chmod a+x /init.sh && \
    /init.sh
