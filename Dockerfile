# Container image that runs your code
FROM node:18
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq \ 
    && chmod +x /usr/bin/yq
RUN yq --version
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
