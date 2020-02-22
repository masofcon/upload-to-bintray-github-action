FROM alpine:3.11.0

LABEL "maintainer"="George Suaridze"
LABEL "com.github.actions.name"="upload-to-bintray-github-action"
LABEL "com.github.actions.description"="Upload files to JFrog Bintray"
LABEL "com.github.actions.icon"="upload"
LABEL "com.github.actions.color"="green"

RUN apk --no-cache add curl jq

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]