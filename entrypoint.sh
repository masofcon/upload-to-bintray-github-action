#!/bin/sh

REPOSITORY=$1
PACKAGE=$2
VERSION=$3
SOURCE_PATH=$4
UPLOAD_PATH=$5
EXPLODE=$6
OVERRIDE=$7
PUBLISH=$8

UPLOADED=0
for FILE in ${SOURCE_PATH}; do
    UPLOAD_URL=${INPUT_API_URL}/content/${INPUT_API_USER}/${REPOSITORY}/${UPLOAD_PATH}/$(basename $FILE)
    echo "=== Uploading ${FILE} to ${UPLOAD_URL}"
    RESULT=$(curl -T ${FILE} \
            -u${INPUT_API_USER}:${INPUT_API_KEY} \
            -H "X-Bintray-Package:${PACKAGE}" \
            -H "X-Bintray-Version:${VERSION}" \
            -H "X-Bintray-Override:${OVERRIDE}" \
            -H "X-Bintray-Explode:${EXPLODE}" \
            ${UPLOAD_URL})

    if [ "$(echo ${RESULT} | jq -r '.message')" != "success" ]; then
        echo "=== Failed to upload ${FILE} with response: ${RESULT}"
        exit 1
    else
        UPLOADED=$((UPLOADED+1))
        echo "=== ${FILE} uploaded successfully"
    fi
done

if [ "$PUBLISH" == "true" ]; then
    echo "=== Publishing repository [${REPOSITORY}] - package [${PACKAGE}] - version [${VERSION}]"
    PUBLISH_RESULT=$(curl -X POST \
            -u${INPUT_API_USER}:${INPUT_API_KEY} \
            ${INPUT_API_URL}/content/${INPUT_API_USER}/${REPOSITORY}/${PACKAGE}/${VERSION}/publish)

    if [ $(echo ${PUBLISH_RESULT} | jq -r '.files') -lt ${UPLOADED} ]; then
        echo "=== Not all files are published successfully, response: ${PUBLISH_RESULT}"
        exit 1
    else
        echo "=== Published successfully"
    fi
fi