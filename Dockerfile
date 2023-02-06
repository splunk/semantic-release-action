# Container image that runs your code
FROM node:18
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN snap install yq
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
