# Container image that runs your code
FROM node:18
COPY entrypoint.sh /entrypoint.sh
# Code file to execute when the docker container starts up (`entrypoint.sh`)
ENTRYPOINT ["/entrypoint.sh"]
#RUN npm install @semantic-release/changelog @semantic-release/git @semantic-release/exec
